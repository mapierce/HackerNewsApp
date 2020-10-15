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
    @Published var images: [Image?] = []
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
        handleImageRepository()
        handleItemRepository()
        fetchIds()
    }
    
    // MARK: - Public methods
    
    func retry() {
        viewStateInternal = .loading
        fetchIds()
    }
    
    func cellAppeared(at index: Int) {
        fetchItems(from: index)
    }
    
    func cellDisappeared(at index: Int) {
        guard index > loadCount else { return }
        itemRepository.cancel(by: itemIds[index])
        imageRepository.cancel(by: itemIds[index])
    }
    
    func reloadItem(at index: Int) {
        items[index] = .loading
        itemRepository.fetch(by: itemIds[index])
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
        itemIds.forEach { [unowned self] _ in
            self.items.append(.loading)
            self.images.append(nil)
        }
        fetchItems(from: 0)
    }
    
    private func fetchItems(from startIndex: Int) {
        defer { viewStateInternal = .complete }
        for index in startIndex..<startIndex + loadCount {
            guard index < itemIds.count else { return }
            itemRepository.fetch(by: itemIds[index])
        }
    }
    
    private func handleItemRepository() {
        itemRepository.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (id, value) in
                guard let index = self?.itemIds.firstIndex(of: id) else { return }
                if let item = value {
                    self?.items[index] = .complete(item)
                    let imageUrl = URL(string: item.url ?? "")
                    self?.imageRepository.fetch(by: (id, imageUrl), forceRefresh: false)
                } else {
                    self?.items[index] = .error
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleImageRepository() {
        imageRepository.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (id, image) in
                guard let index = self?.itemIds.firstIndex(of: id) else { return }
                self?.images[index] = image
            }
            .store(in: &cancellables)
    }
    
}
