//
//  CommentItemViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 26/10/2020.
//

import Foundation
import Combine
import SwiftSoup

class CommentItemViewModel: ObservableObject {
    
    @Published private(set) var text = ""
    @Published private(set) var metadata = "Unknown"
    @Published private(set) var commentCount = 0
    private let commentId: Int
    private let itemRepository: ItemRespository
    private var cancellables: Set<AnyCancellable> = []
    
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
        guard case .comment(let commentItem) = item, let commentText = commentItem.text else { return }
        commentCount = commentItem.kids?.count ?? 0
        if let data = item?.buildMetadata() {
            metadata = data
        }
        do {
            text = try SwiftSoup.parse(commentText).text()
        } catch {
            text = "Comment couldn't be loaded"
        }
    }
    
}
