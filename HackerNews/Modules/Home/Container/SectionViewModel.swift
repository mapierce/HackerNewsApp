//
//  SectionViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 23/07/2020.
//

import Foundation
import Combine

class SectionViewModel: ObservableObject {
    
    @Published private(set) var itemIds = [Int]()
    private let transport: Transport
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(transport: Transport = URLSession.shared) {
        self.transport = transport
        fetchIds()
    }
    
    // MARK: - Private methods
    
    private func fetchIds() {
        let request = URLRequest(path: .topStories)
        transport.checkingStatusCode().send(request: request).receive(on: DispatchQueue.main).sink { completion in
            switch completion {
            case .failure(let error): print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { response in
            self.itemIds = response
        }
        .store(in: &cancellables)
    }
}
