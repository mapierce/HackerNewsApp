//
//  ItemRepository.swift
//  HackerNews
//
//  Created by Matthew Pierce on 27/07/2020.
//

import Foundation
import Combine

class ItemRespository: Repository, ObservableObject {
    
    private let subject = PassthroughSubject<Item?, Error>()
    private let transport: Transport
    private let cache: ItemCache
    private var cancellable: AnyCancellable?
    
    var publisher: AnyPublisher<Item?, Error> {
        subject.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    
    init(transport: Transport = URLSession.shared, cache: ItemCache = ItemCache.shared) {
        self.transport = transport
        self.cache = cache
    }
    
    // MARK: - Repository methods
    
    func fetch(by identifier: Int, forceRefresh: Bool = false) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            if let existingItem = strongSelf.cache.read(id: identifier) {
                strongSelf.subject.send(existingItem)
                return
            }
            let request = URLRequest(path: Path.item.rawValue.format(identifier))
            strongSelf.cancellable = strongSelf.transport
                .checkingStatusCode()
                .send(request: request)
                .replaceError(with: nil)
                .sink { completion in
                    switch completion {
                    case .failure(let error): strongSelf.subject.send(completion: .failure(error))
                    case .finished: break
                    }
                } receiveValue: { response in
                    strongSelf.updateStoredResponse(response)
                }
        }
    }
    
    func clearCache() {
        cache.clear()
    }
    
    // MARK: - Public methods
    
    func cancel() {
        cancellable?.cancel()
    }
    
    // MARK: - Private methods
    
    private func updateStoredResponse(_ item: Item?) {
        defer { subject.send(item) }
        guard let item = item else { return }
        cache.write(item, for: item.id)
    }
    
}
