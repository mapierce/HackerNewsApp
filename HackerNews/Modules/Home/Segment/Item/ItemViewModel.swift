//
//  ItemViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation
import Combine

class ItemViewModel: ObservableObject {
    
    @Published private(set) var item: Item?
    private let repository: ItemRespository
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(repository: ItemRespository = ItemRespository(), itemId: Int) {
        self.repository = repository
        repository.publisher.sink { completion in
            switch completion {
            case .failure(let error): print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { [weak self] item in
            self?.item = item
        }
        .store(in: &cancellables)

        repository.fetch(itemId: itemId, forceRefresh: false)
    }

}
