//
//  Repository.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation
import Combine

protocol ItemRepository {
    
    var storedResponse: [Int: Item]? { get }
    
    func fetch(itemId: Int, forceRefresh: Bool)

    func clearCache()
    
}

class ItemRespositoryBase: ItemRepository, ObservableObject {
    
    @Published private(set) var storedResponse: [Int: Item]? = [:]
    private let transport: Transport
    private var cancellables: Set<AnyCancellable> = []
    static let shared = ItemRespositoryBase()
    
    init(transport: Transport = URLSession.shared) {
        self.transport = transport
    }
    
    func fetch(itemId: Int, forceRefresh: Bool = false) {
        let request = URLRequest(path: Path.item.rawValue.format(itemId))
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
                self?.storedResponse?[response.id] = response
            }
            .store(in: &cancellables)
    }
    
    func clearCache() {
        storedResponse = nil
    }
    
}
