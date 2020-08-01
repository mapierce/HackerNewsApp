//
//  ImageCache.swift
//  HackerNews
//
//  Created by Matthew Pierce on 01/08/2020.
//

import SwiftUI

final class ImageCache: Cache {
    
    static let shared = ImageCache()
    private var cache: [URL: Image] = [:]
    
    // MARK: - Cache methods
    
    func write(_ item: Image, for id: URL) {
        cache[id] = item
    }
    
    func read(id: URL) -> Image? {
        cache[id]
    }
    
    func clear() {
        cache = [:]
    }
    
}
