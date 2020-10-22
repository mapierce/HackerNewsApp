//
//  ImageCache.swift
//  HackerNews
//
//  Created by Matthew Pierce on 01/08/2020.
//

import SwiftUI

final class ImageCache: Cache {
    
    static let shared = ImageCache()
    private var cache: [Int: ImageType] = [:]
    
    // MARK: - Cache methods
    
    func write(_ item: ImageType, for id: Int) {
        cache[id] = item
    }
    
    func read(id: Int) -> ImageType? {
        cache[id]
    }
    
    func clear() {
        cache = [:]
    }
    
}
