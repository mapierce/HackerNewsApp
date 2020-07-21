//
//  StatusCodeCheckingTransport.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import Foundation
import Combine

struct StatusCodeCheckingTransport: Transport {
    
    let wrapped: Transport
    let expectedRange: Range<Int>
    
    func send(request: URLRequest) -> AnyPublisher<Response, NetworkError> {
        wrapped.send(request: request).tryMap { (data, httpResponse) -> Response in
            guard self.expectedRange ~= httpResponse.statusCode else {
                throw NetworkError.statusCode
            }
            return (data, httpResponse)
        }
        .mapError { NetworkError.map($0) }
        .eraseToAnyPublisher()
    }
    
}

extension Transport {
    
    func checkingStatusCode(expectedRange: Range<Int> = 200..<300) -> Transport {
        return StatusCodeCheckingTransport(wrapped: self, expectedRange: expectedRange)
    }
    
}
