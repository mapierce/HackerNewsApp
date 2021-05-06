//
//  CommentListViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 29/09/2020.
//

import Foundation

class CommentContainerViewModel: ObservableObject {
    
    let commentIds: [Int]?
    private let itemRepository: ItemRespository
    
    // MARK: - Initialization
    
    init(commentIds: [Int]?, itemRepository: ItemRespository = ItemRespository()) {
        self.commentIds = commentIds
        self.itemRepository = itemRepository
    }
    
}
