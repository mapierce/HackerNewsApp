//
//  Transport.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import Foundation
import Combine

protocol Transport {
    
    func send(request: URLRequest) -> AnyPublisher<Response, NetworkError>
    
}

extension Transport {
    
    func send<T: Decodable>(request: URLRequest) -> AnyPublisher<T, NetworkError> {
        send(request: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { NetworkError.map($0) }
            .eraseToAnyPublisher()
    }
    
}
