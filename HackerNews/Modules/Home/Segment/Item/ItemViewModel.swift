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
    private let repository: ItemRespositoryBase
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(repository: ItemRespositoryBase = ItemRespositoryBase.shared, itemId: Int) {
        self.repository = repository
        self.item = repository.storedResponse?[itemId]
        repository.fetch(itemId: itemId, forceRefresh: false)
    }

}
