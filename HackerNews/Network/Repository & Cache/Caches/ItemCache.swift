//
//  ItemCache.swift
//  HackerNews
//
//  Created by Matthew Pierce on 27/07/2020.
//

import Foundation

final class ItemCache: Cache {
    
    static let shared = ItemCache()
    private var cache: [Int: Item] = [:]
    
    // MARK: - Cache methods
    
    func write(_ item: Item) {
        cache[item.id] = item
    }
    
    func read(id: Int) -> Item? {
        cache[id]
    }
    
    func clear() {
        cache = [:]
    }
    
}
