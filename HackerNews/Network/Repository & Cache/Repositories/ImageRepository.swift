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
    
    // TODO: - Use ImageDataProvider to load local images, and use Prefetch to load others. Then the subject should
    // return the item id and a KFImage
    
    private struct Constants {
        
        static let propertyAttribute = "property"
        static let imageValue = "og:image"
        static let contentAttribute = "content"
        
    }

    typealias Identifier = (id: Int, endpoint: URL?)
    
    private let backgroundSyncQueue = DispatchQueue(label: "backgroundSyncQueue")
    private let subject = PassthroughSubject<(id: Int, image: ImageType), Never>()
    private let transport: Transport
    private let cache: ImageCache
    private let placeholderImageLoader: PlaceholderImageLoader
    private var cancellables: [Int: AnyCancellable] = [:]
    
    var publisher: AnyPublisher<(id: Int, image: ImageType), Never> {
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
        // FIXME: Ensure correct queueing
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let strongSelf = self else { return }
            if let existingImageType = strongSelf.cache.read(id: identifier.id) {
                strongSelf.subject.send((identifier.id, existingImageType))
                return
            }
            if let endpoint = identifier.endpoint, let imageURL = strongSelf.getImageURL(from: endpoint) {
//                strongSelf.backgroundSyncQueue.sync {
                    strongSelf.cache.write(.remote(imageURL), for: identifier.id)
                    strongSelf.subject.send((identifier.id, .remote(imageURL)))
                    return
//                }
            }
            let placeHolderImageName = strongSelf.placeholderImageLoader.getNextPlaceholderImageName()
//            strongSelf.backgroundSyncQueue.sync {
                strongSelf.cache.write(.local(placeHolderImageName), for: identifier.id)
                strongSelf.subject.send((identifier.id, .local(placeHolderImageName)))
//            }
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
