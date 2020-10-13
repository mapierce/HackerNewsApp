//
//  ItemViewState.swift
//  HackerNews
//
//  Created by Matthew Pierce on 02/10/2020.
//

import Foundation

enum ItemViewState {
    case loading
    case error
    case complete(Item)
}
