//
//  CommentItemViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 26/10/2020.
//

import Foundation
import Combine
import SwiftSoup
import SwiftUI

class CommentItemViewModel: ObservableObject {
    
    // MARK: - Constants
    
    private struct Constants {
        
        static let commentFallback = "Comment couldn't be loaded"
        static let metadataFallback = "Unknown"
        
    }
    
    @Published private(set) var text = ""
    @Published private(set) var metadata = ""
    @Published private(set) var commentCount = 0
    @Published private(set) var viewState: ViewState = .loading
    private let commentId: Int
    private let itemRepository: ItemRespository
    private var cancellables: Set<AnyCancellable> = []
    
    private var viewStateInternal: ViewState = .loading {
        willSet {
            withAnimation {
                viewState = newValue
            }
        }
    }
    
    // MARK: - Initialization
    
    init(commentId: Int, itemRepository: ItemRespository = ItemRespository()) {
        self.commentId = commentId
        self.itemRepository = itemRepository
        handleItemRepository()
        self.itemRepository.fetch(by: commentId)
    }
    
    // MARK: - Private methods
    
    private func handleItemRepository() {
        itemRepository.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (id, value) in
                self?.handle(value)
            }
            .store(in: &cancellables)
    }
    
    private func handle(_ item: Item?) {
        guard case .comment(let commentItem) = item, let commentText = commentItem.text else {
            viewStateInternal = .error
            return
        }
        viewStateInternal = .complete
        commentCount = commentItem.kids?.count ?? 0
        metadata = item?.buildMetadata() ?? Constants.metadataFallback
        text = (try? SwiftSoup.parse(commentText).text()) ?? Constants.commentFallback
    }
    
}
