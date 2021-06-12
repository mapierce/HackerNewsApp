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
        fetchIds()
    }
    
    // MARK: - Public methods
    
    func retry() {
        viewStateInternal = .loading
        fetchIds()
    }
    
    func reload() async {
        itemIds.forEach {
            itemRepository.cancel(by: $0)
            imageRepository.cancel(by: $0)
        }
        itemIds = []
        return await withCheckedContinuation { [unowned self] continuation in
            fetchIds { result in
                switch result {
                case .success(let newIds):
                    itemIds = newIds
                    continuation.resume(returning: ())
                case .failure: viewStateInternal = .error
                }
            }
        }
    }
    
    func cellAppeared(at index: Int) {
        fetchItems(from: index)
    }
    
    func cellDisappeared(at index: Int) {
        guard index > loadCount else { return }
        itemRepository.cancel(by: itemIds[index])
    }
    
    // MARK: - Private methods
    
    private func fetchIds() {
        fetchIds { [weak self] result in
            switch result {
            case .success(let itemIds): self?.handle(response: itemIds)
            case .failure: self?.viewStateInternal = .error
            }
        }
    }
    
    private func fetchIds(with completion: @escaping (Result<[Int], Error>) -> Void) {
        let request = URLRequest(path: segment.associatedPath)
        transport
            .checkingStatusCode()
            .send(request: request)
            .receive(on: DispatchQueue.main)
            .sink { completionHandler in
                switch completionHandler {
                case .failure(let error): completion(.failure(error))
                case .finished: break
                }
            } receiveValue: { response in
                completion(.success(response))
            }
            .store(in: &cancellables)
    }
    
    private func handle(response: [Int]) {
        viewStateInternal = .complete
        itemIds = response
        fetchItems(from: 0)
    }
    
    private func fetchItems(from startIndex: Int) {
        for index in startIndex..<startIndex + loadCount {
            guard index < itemIds.count else { return }
            itemRepository.fetch(by: itemIds[index])
        }
    }
    
}
