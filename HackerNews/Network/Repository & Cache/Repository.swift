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
    associatedtype Identifier
    
    var publisher: AnyPublisher<RepositoryItem, Never> { get }
    
    func fetch(by identifier: Identifier, forceRefresh: Bool)
    func clearCache()
    
}

extension Repository {
    
    func clearCache() {}
    
}
