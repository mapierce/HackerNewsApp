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
    private let metadataProvider = LPMetadataProvider()
    private let cache: ImageCache
    private var cancellables: Set<AnyCancellable> = []
    
    var publisher: AnyPublisher<Image, Error> {
        subject.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    
    init(cache: ImageCache = ImageCache.shared) {
        self.cache = cache
    }

    // MARK: - Repository methods
    
    func fetch(by identifier: URL, forceRefresh: Bool) {
        if let existingImage = cache.read(id: identifier) {
            subject.send(existingImage)
            return
        }
        getMetadata(from: identifier)
            .flatMap(getImage)
            .sink { completion in
                switch completion {
                case .failure(let error): print(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { [unowned self] image in
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
                if let error = error {
                    promise(.failure(error))
                    return
                }
                guard let imageProvider = metadata?.imageProvider else {
                    promise(.failure(ImageError.noImageProvider))
                    return
                }
                promise(.success(imageProvider))
            }
        }
    }
    
    private func getImage(from itemProvider: NSItemProvider) -> Future<Image, Error> {
        return Future { promise in
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let image = image as? UIImage else {
                    promise(.failure(ImageError.noImageData))
                    return
                }
                promise(.success(Image(uiImage: image)))
            }
        }
    }
    
}
