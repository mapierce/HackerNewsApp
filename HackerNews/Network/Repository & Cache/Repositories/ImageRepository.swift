//
//  ImageRepository.swift
//  HackerNews
//
//  Created by Matthew Pierce on 29/07/2020.
//

import SwiftUI
import Combine
import SwiftSoup

class ImageRepository: Repository, ObservableObject {
    
    private struct Constants {
        
        static let propertyAttribute = "property"
        static let imageValue = "og:image"
        static let contentAttribute = "content"
        
    }

    typealias Identifier = (id: Int, endpoint: URL?)
    
    private let backgroundSyncQueue = DispatchQueue(label: "backgroundSyncQueue")
    private let subject = PassthroughSubject<(id: Int, image: Image), Never>()
    private let transport: Transport
    private let cache: ImageCache
    private let placeholderImageLoader: PlaceholderImageLoader
    private var cancellables: [Int: AnyCancellable] = [:]
    
    var publisher: AnyPublisher<(id: Int, image: Image), Never> {
        subject.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    
    init(
        transport: Transport = URLSession.shared,
        cache: ImageCache = ImageCache.shared,
        placeholderImageLoader: PlaceholderImageLoader = PlaceholderImageLoader.shared
    ) {
        self.transport = transport
        self.cache = cache
        self.placeholderImageLoader = placeholderImageLoader
    }

    // MARK: - Repository methods
    
    func fetch(by identifier: Identifier, forceRefresh: Bool) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let strongSelf = self else { return }
            if let existingImage = strongSelf.cache.read(id: identifier.id) {
                strongSelf.subject.send((identifier.id, existingImage))
                return
            }
            guard let endpoint = identifier.endpoint, let imageURL = strongSelf.getImageURL(from: endpoint) else {
                let image = strongSelf.placeholderImageLoader.getNextPlaceholderImage()
                strongSelf.subject.send((identifier.id, image))
                strongSelf.backgroundSyncQueue.sync {
                    strongSelf.cache.write(image, for: identifier.id)
                }
                return
            }
            let request = URLRequest(url: imageURL)
            strongSelf.backgroundSyncQueue.sync {
                strongSelf.cancellables[identifier.id] = strongSelf.transport
                    .checkingStatusCode()
                    .send(request: request)
                    .tryMap({ (data, _) -> Image in try strongSelf.dataToImage(data) })
                    .catch({ _ -> Just<Image> in Just(strongSelf.placeholderImageLoader.getNextPlaceholderImage()) })
                    .sink(receiveValue: { image in
                        strongSelf.subject.send((identifier.id, image))
                        strongSelf.cache.write(image, for: identifier.id)
                    })
            }
        }
    }
    
    func clearCache() {
        cache.clear()
    }
    
    // MARK: - Public methods
    
    func cancel(by identifier: Int) {
        guard let cancellable = cancellables[identifier] else { return }
        cancellable.cancel()
    }
    
    // MARK: - Private methods
    
    func getImageURL(from source: URL) -> URL? {
        do {
            let contents = try String(contentsOf: source)
            let doc = try SwiftSoup.parse(contents)
            let imageElements = try doc.head()?.getElementsByAttributeValue(Constants.propertyAttribute, Constants.imageValue)
            guard let element = imageElements?.array().first,
                  let imageStringURL = try? element.attr(Constants.contentAttribute),
                  let imageURL = URL(string: imageStringURL) else { return nil }
            return imageURL
        } catch { return nil }
    }
    
    func dataToImage(_ data: Data) throws -> Image {
        guard let uiImage = UIImage(data: data) else {
            throw ImageError.dataToImageFailure
        }
        return Image(uiImage: uiImage)
    }
    
}
