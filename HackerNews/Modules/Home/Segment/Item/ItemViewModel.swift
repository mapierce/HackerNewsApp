//
//  ItemViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation
import Combine

class ItemViewModel: ObservableObject {
    
    @Published private(set) var title = "Placeholder text going in here just for the redaction"
    @Published private(set) var metadata = "Placeholder text going in here just for the redaction"
    @Published private(set) var loading = true
    private let repository: ItemRespository
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(repository: ItemRespository = ItemRespository(), itemId: Int) {
        self.repository = repository
        handleRepository()
        fetch(itemId)
    }
    
    // MARK: - Private methods
    
    private func handleRepository() {
        repository.publisher.sink { completion in
            switch completion {
            case .failure(let error): print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { [weak self] item in
            self?.handle(item: item)
        }
        .store(in: &cancellables)
    }
    
    private func fetch(_ itemId: Int) {
        repository.fetch(itemId: itemId, forceRefresh: false)
    }
    
    private func handle(item: Item) {
        loading = false
        title = "\(item.uuid)"
        metadata = "By \(item.by ?? "no one")"
    }

}
