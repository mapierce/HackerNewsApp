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
    private var viewStateInternal: ViewState = .loading {
        willSet {
            withAnimation {
                viewState = newValue
            }
        }
    }
    private let transport: Transport
    private let segment: Segment
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(transport: Transport = URLSession.shared, segment: Segment) {
        self.transport = transport
        self.segment = segment
        fetchIds()
    }
    
    // MARK: - Public methods
    
    func retry() {
        viewStateInternal = .loading
        fetchIds()
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
        viewStateInternal = .complete
    }
    
}
