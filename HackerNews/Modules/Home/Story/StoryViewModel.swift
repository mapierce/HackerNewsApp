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
    
    private struct Constants {
        
        static let fallbackStoryTitle = "HackerNews: Story"
        static let fallbackJobTitle = "HackerNews: Job"
        static let fallbackPollTitle = "HackerNews: Poll"
        
    }
    
    @Published private(set) var viewType: ViewType = .loading
    @Published private(set) var title = ""
    @Published private(set) var commentIds: [Int]? = nil
    private let itemId: Int
    private let itemRepository: ItemRespository
    private var cancellables: Set<AnyCancellable> = []
    
    private var viewTypeInternal: ViewType = .loading {
        willSet {
            withAnimation {
                viewType = newValue
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
    
    func fetch() {
        itemRepository.fetch(by: itemId)
    }
    
    // MARK: - Private methods
    
    private func handleItemRepository() {
        itemRepository.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure: self?.viewTypeInternal = .error
                case .finished: break
                }
            } receiveValue: { [weak self] item in
                self?.handle(item)
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
            title = storyItem.title ?? Constants.fallbackStoryTitle
        case .job(let jobItem):
            if let url = jobItem.url {
                viewTypeInternal = .web(URLRequest(string: url))
            } else {
                viewTypeInternal = .native
            }
            title = jobItem.title ?? Constants.fallbackJobTitle
        case .poll(let pollItem):
            title = pollItem.title ?? Constants.fallbackPollTitle
            viewTypeInternal = .native
        default:
            viewTypeInternal = .error
            return
        }
    }
    
}
