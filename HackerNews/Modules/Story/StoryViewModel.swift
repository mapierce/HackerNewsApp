//
//  StoryViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 25/08/2020.
//

import SwiftUI
import Combine

enum ViewType {
    case loading
    case web(URLRequest)
    case native
    case error
}

class StoryViewModel: ObservableObject {
    
    @Published private(set) var viewType: ViewType = .loading
    @Published private(set) var title = ""
    @Published private(set) var commentIds: [Int]? = nil
    private let itemId: Int
    private let itemRepository: ItemRespository
    private var cancellables: Set<AnyCancellable> = []
    
    private var viewTypeInternal: ViewType = .loading {
        didSet {
            withAnimation {
                viewType = viewTypeInternal
            }
        }
    }
    
    // MARK: - Initialization
    
    init(itemId: Int, itemRepository: ItemRespository = ItemRespository()) {
        self.itemId = itemId
        self.itemRepository = itemRepository
        handleItemRepository()
    }
    
    // MARK: - Public methods
    
    func onAppear() {
        itemRepository.fetch(by: itemId)
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
        guard let item = item else {
            viewTypeInternal = .error
            return
        }
        commentIds = item.kids
        switch item {
        case .story(let storyItem):
            if let url = storyItem.url {
                viewTypeInternal = .web(URLRequest(string: url))
            } else {
                viewTypeInternal = .native
            }
            title = storyItem.title
        case .job(let jobItem):
            if let url = jobItem.url {
                viewTypeInternal = .web(URLRequest(string: url))
            } else {
                viewTypeInternal = .native
            }
            title = jobItem.title
        case .poll(let pollItem):
            title = pollItem.title
            viewTypeInternal = .native
        default:
            viewTypeInternal = .error
            return
        }
    }
    
}
