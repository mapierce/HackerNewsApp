//
//  ItemRepository.swift
//  HackerNews
//
//  Created by Matthew Pierce on 27/07/2020.
//

import Foundation
import Combine

class ItemRespository: Repository, ObservableObject {
    
    private let subject = PassthroughSubject<(id: Int, value: Item?), Never>()
    private let transport: Transport
    private let cache: ItemCache
    private var cancellables: [Int: AnyCancellable] = [:]
    
    var publisher: AnyPublisher<(id: Int, value: Item?), Never> {
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
            subject.send((identifier, existingItem))
            return
        }
        let request = URLRequest(path: Path.item.rawValue.format(identifier))
        cancellables[identifier] = transport
            .checkingStatusCode()
            .send(request: request)
            .replaceError(with: nil)
            .sink(receiveValue: { [weak self] response in
                self?.updateStoredResponse(for: identifier, item: response)
            })
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
    
    private func updateStoredResponse(for identifier: Int, item: Item?) {
        defer { subject.send((identifier, item)) }
        guard let item = item else { return }
        cache.write(item, for: item.id)
    }
    
}
