//
//  SegmentViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 23/07/2020.
//

import Foundation
import Combine

class SegmentViewModel: ObservableObject {
    
    @Published private(set) var itemIds = [Int]()
    @Published private(set) var error = false
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
        error = false
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
                case .failure: self?.error = true
                case .finished: break
                }
        } receiveValue: { response in
            self.itemIds = response
        }
        .store(in: &cancellables)
    }
    
}
