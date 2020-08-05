//
//  ImageRepository.swift
//  HackerNews
//
//  Created by Matthew Pierce on 29/07/2020.
//

import SwiftUI
import Combine
import LinkPresentation

class ImageRepository: Repository, ObservableObject {
    
    private let subject = PassthroughSubject<Image, Error>()
    private let cache: ImageCache
    private let metadataProvider = LPMetadataProvider()
    private let placeholderImageLoader: PlaceholderImageLoader
    private var cancellables: Set<AnyCancellable> = []
    
    var publisher: AnyPublisher<Image, Error> {
        subject.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    
    init(cache: ImageCache = ImageCache.shared, placeholderImageLoader: PlaceholderImageLoader = PlaceholderImageLoader.shared) {
        self.cache = cache
        self.placeholderImageLoader = placeholderImageLoader
    }

    // MARK: - Repository methods
    
    func fetch(by identifier: URL?, forceRefresh: Bool) {
        print("-=-=-=-=- Fetching image for: \(identifier?.absoluteString ?? "no identifier provided")")
        guard let identifier = identifier else {
            print("-=-=-=-=- Identifier is nil, returning placeholder image")
            subject.send(placeholderImageLoader.getNextPlaceholderImage())
            return
        }
        if let existingImage = cache.read(id: identifier) {
            print("-=-=-=-=- Have existing image for identifier: \(identifier.absoluteString)")
            subject.send(existingImage)
            return
        }
        getMetadata(from: identifier)
            .flatMap(getImage)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("-=-=-=-=- Entire repo failure for: \(identifier.absoluteString)")
                    print(error.localizedDescription)
                case .finished:
                    print("-=-=-=-=- Entire repo finished for: \(identifier.absoluteString)")
                    break
                }
            } receiveValue: { [unowned self] image in
                print("-=-=-=-=- Entire repo success for: \(identifier.absoluteString)")
                self.cache.write(image, for: identifier)
                self.subject.send(image)
            }
            .store(in: &cancellables)
    }
    
    func clearCache() {
        cache.clear()
    }
    
    // MARK: - Private methods
    
    private func getMetadata(from url: URL) -> Future<NSItemProvider, Error> {
        return Future { [unowned self] promise in
            self.metadataProvider.startFetchingMetadata(for: url) { metadata, error in
                print("-=-=-=-=- Fetching metadata for: \(url.absoluteString)")
                if let error = error {
                    print("-=-=-=-=- Error fetching metadata for: \(url.absoluteString)")
                    promise(.failure(error))
                    return
                }
                guard let imageProvider = metadata?.imageProvider else {
                    print("-=-=-=-=- No image provider metadata for: \(url.absoluteString)")
                    promise(.failure(ImageError.noImageProvider))
                    return
                }
                print("-=-=-=-=- Got metadata for: \(url.absoluteString)")
                promise(.success(imageProvider))
            }
        }
    }
    
    private func getImage(from itemProvider: NSItemProvider) -> Future<Image, Error> {
        return Future { promise in
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                print("-=-=-=-=- Loading image...")
                guard let image = image as? UIImage else {
                    print("-=-=-=-=- No image found")
                    promise(.failure(ImageError.noImageData))
                    return
                }
                print("-=-=-=-=- Returning image")
                promise(.success(Image(uiImage: image)))
            }
        }
    }
    
}
