//
//  Cache.swift
//  HackerNews
//
//  Created by Matthew Pierce on 27/07/2020.
//

import Foundation

protocol Cache {
    
    associatedtype ID
    associatedtype CacheItem
    
    func write(_ item: CacheItem, for id: ID)
    func read(id: ID) -> CacheItem?
    func clear()
    
}
