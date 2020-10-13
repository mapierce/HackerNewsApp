//
//  SegmentViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 23/07/2020.
//

import SwiftUI
import Combine

class SegmentViewModel: ObservableObject {
    
    @Published private(set) var itemIds = [Int]()
    @Published private(set) var viewState: ViewState = .loading
    @Published var items: [ItemViewState] = []
    private let transport: Transport
    private let segment: Segment
    private let itemRepository: ItemRespository
    private let imageRepository: ImageRepository
    private var cancellables: Set<AnyCancellable> = []
    private let loadCount = 10
    
    private var viewStateInternal: ViewState = .loading {
        willSet {
            withAnimation {
                viewState = newValue
            }
        }
    }
    
    // MARK: - Initialization
    
    init(
        transport: Transport = URLSession.shared,
        segment: Segment,
        itemRepository: ItemRespository = ItemRespository(),
        imageRepository: ImageRepository = ImageRepository()
    ) {
        self.transport = transport
        self.segment = segment
        self.itemRepository = itemRepository
        self.imageRepository = imageRepository
        handleItemRepository()
        fetchIds()
    }
    
    // MARK: - Public methods
    
    func retry() {
        viewStateInternal = .loading
        fetchIds()
    }
    
    func cellAppear(_ index: Int) {
        fetchItems(from: index)
    }
    
    func cellDisappear(_ index: Int) {
        guard index > loadCount else { return }
        itemRepository.cancel(by: itemIds[index])
    }
    
    // MARK: - Private methods
    
    private func fetchIds() {
        let request = URLRequest(path: segment.associatedPath)
        transport
            .checkingStatusCode()
            .send(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure: self?.viewStateInternal = .error
                case .finished: break
                }
        } receiveValue: { [weak self] response in
            self?.handle(response: response)
        }
        .store(in: &cancellables)
    }
    
    private func handle(response: [Int]) {
        itemIds = response
        itemIds.forEach { [unowned self] _ in self.items.append(.loading) }
        fetchItems(from: 0)
    }
    
    private func fetchItems(from startIndex: Int) {
        for index in startIndex..<startIndex + loadCount {
            guard index < itemIds.count else { return }
            itemRepository.fetch(by: itemIds[index])
        }
        viewStateInternal = .complete
    }
    
    private func handleItemRepository() {
        itemRepository.publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (id, value) in
                guard let index = self?.itemIds.firstIndex(of: id), let item = value else { return }
                self?.items[index] = .complete(item)
            })
            .store(in: &cancellables)
    }
    
}
