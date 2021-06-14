//
//  ItemViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 02/11/2020.
//

import Foundation
import Combine

class ItemViewModel: ObservableObject {
    
    @Published private(set) var item: Item?
    @Published private(set) var image: ImageType?
    @Published private(set) var error = false
    let itemId: Int
    private let transport: Transport
    private let itemRepository: ItemRespository
    private let imageRepository: ImageRepository
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(
        itemId: Int,
        transport: Transport = URLSession.shared,
        itemRepository: ItemRespository = ItemRespository(),
        imageRepository: ImageRepository = ImageRepository()
    ) {
        self.itemId = itemId
        self.transport = transport
        self.itemRepository = itemRepository
        self.imageRepository = imageRepository
        handleItemRepository()
        handleImageRepository()
    }
    
    // MARK: - Public methods
    
    func onAppeared() {
        guard item == nil else { return }
        itemRepository.fetch(by: itemId)
    }
    
    func reload() {
        error = false
        itemRepository.fetch(by: itemId)
    }
    
    // MARK: - Private methods
    
    private func handleItemRepository() {
        itemRepository
            .publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (id, value) in
                if let item = value {
                    self?.error = false
                    self?.item = item
                    let imageUrl = URL(string: item.url ?? "")
                    self?.imageRepository.fetch(by: (id, imageUrl), forceRefresh: false)
                } else {
                    self?.error = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleImageRepository() {
        imageRepository
            .publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (id, image) in
                self?.image = image
            }
            .store(in: &cancellables)
    }
    
}
