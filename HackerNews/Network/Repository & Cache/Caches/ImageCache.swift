//
//  ImageCache.swift
//  HackerNews
//
//  Created by Matthew Pierce on 01/08/2020.
//

import SwiftUI

final class ImageCache: Cache {
    
    static let shared = ImageCache()
    private var cache: [Int: Image] = [:]
    
    // MARK: - Cache methods
    
    func write(_ item: Image, for id: Int) {
        cache[id] = item
    }
    
    func read(id: Int) -> Image? {
        cache[id]
    }
    
    func clear() {
        cache = [:]
    }
    
}
