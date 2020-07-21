//
//  NetworkError.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import Foundation

enum NetworkError: Error {
    
    case statusCode
    case decoding
    case invalidImage
    case invalidURL
    case other(Error)
    
    static func map(_ error: Error) -> NetworkError {
        return (error as? NetworkError) ?? .other(error)
    }
    
}
