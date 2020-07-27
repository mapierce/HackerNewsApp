//
//  Cache.swift
//  HackerNews
//
//  Created by Matthew Pierce on 27/07/2020.
//

import Foundation

protocol Cache {
    
    associatedtype ID
    associatedtype CacheItem: Identifiable where CacheItem.ID == ID
    
    func write(_ item: CacheItem)
    func read(id: ID) -> CacheItem?
    func clear()
    
}
