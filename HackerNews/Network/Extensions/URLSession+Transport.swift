//
//  URLSession+Transport.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import Foundation
import Combine

extension URLSession: Transport {
    
    func send(request: URLRequest) -> AnyPublisher<Response, NetworkError> {
        return dataTaskPublisher(for: request).tryMap { (data, response) -> Response in
            guard let httpURLResponse = response as? HTTPURLResponse else {
                throw NetworkError.statusCode
            }
            return (data, httpURLResponse)
        }
        .mapError { NetworkError.map($0) }
        .eraseToAnyPublisher()
    }
    
}
