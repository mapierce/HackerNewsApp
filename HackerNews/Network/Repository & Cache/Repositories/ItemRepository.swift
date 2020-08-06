//
//  ItemRepository.swift
//  HackerNews
//
//  Created by Matthew Pierce on 27/07/2020.
//

import Foundation
import Combine

class ItemRespository: Repository, ObservableObject {
    
    private let subject = PassthroughSubject<Item, Error>()
    private let transport: Transport
    private let cache: ItemCache
    private var cancellable: AnyCancellable?
    
    var publisher: AnyPublisher<Item, Error> {
        subject.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    
    init(transport: Transport = URLSession.shared, cache: ItemCache = ItemCache.shared) {
        self.transport = transport
        self.cache = cache
    }
    
    // MARK: - Repository methods
    
    func fetch(by identifier: Int, forceRefresh: Bool = false) {
        if let existingItem = cache.read(id: identifier) {
            subject.send(existingItem)
            return
        }
        let request = URLRequest(path: Path.item.rawValue.format(identifier))
        cancellable = transport
            .checkingStatusCode()
            .send(request: request)
            .sink { [weak subject] completion in
                switch completion {
                case .failure(let error): subject?.send(completion: .failure(error))
                case .finished: break
                }
            } receiveValue: { [weak self] response in
                self?.updateStoredResponse(response)
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
    
    private func updateStoredResponse(_ item: Item) {
        cache.write(item, for: item.id)
        subject.send(item)
    }
    
}
