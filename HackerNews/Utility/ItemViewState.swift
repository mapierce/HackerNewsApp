//
//  ItemViewState.swift
//  HackerNews
//
//  Created by Matthew Pierce on 02/10/2020.
//

import Foundation

enum ItemViewState: Equatable {
    
    case loading
    case error
    case complete(Item)
    
    // MARK: - Equatable methods
    
    static func == (lhs: ItemViewState, rhs: ItemViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.error, .error): return true
        case (let .complete(lhsItem), let .complete(rhsItem)): return lhsItem.id == rhsItem.id
        default: return false
        }
    }
    
}
