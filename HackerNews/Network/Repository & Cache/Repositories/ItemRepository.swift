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
    private var cancellables: Set<AnyCancellable> = []
    
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
        transport
            .checkingStatusCode()
            .send(request: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error): print(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { [weak self] response in
                self?.updateStoredResponse(response)
            }
            .store(in: &cancellables)
    }
    
    func clearCache() {
        cache.clear()
    }
    
    // MARK: - Private methods
    
    private func updateStoredResponse(_ item: Item) {
        cache.write(item, for: item.id)
        subject.send(item)
    }
    
}
