//
//  Repository.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation
import Combine

protocol Repository {
    
    associatedtype RepositoryItem
    
    var publisher: AnyPublisher<RepositoryItem, Error> { get }
    
    func fetch(itemId: Int, forceRefresh: Bool)
    func clearCache()
    
}

extension Repository {
    
    func clearCache() {}
    
}
