//
//  CommentListViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 29/09/2020.
//

import Foundation

class CommentListViewModel: ObservableObject {
    
    let commentIds: [Int]?
    
    // MARK: - Initialization
    
    init(commentIds: [Int]?) {
        self.commentIds = commentIds
    }
    
}
