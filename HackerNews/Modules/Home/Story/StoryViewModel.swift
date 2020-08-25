//
//  StoryViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 25/08/2020.
//

import Foundation

class StoryViewModel: ObservableObject {
    
    private let itemId: Int
    private let itemRepository: ItemRespository
    
    // MARK: - Initialization
    
    init(itemId: Int, itemRepository: ItemRespository = ItemRespository()) {
        self.itemId = itemId
        self.itemRepository = itemRepository
    }
    
}
