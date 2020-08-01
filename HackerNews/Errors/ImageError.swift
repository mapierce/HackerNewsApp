//
//  ImageError.swift
//  HackerNews
//
//  Created by Matthew Pierce on 30/07/2020.
//

import Foundation

enum ImageError: Error {
    
    case noImageProvider
    case noImageData
    case other(Error)
    
    static func map(_ error: Error) -> ImageError {
        return (error as? ImageError) ?? .other(error)
    }
    
}
