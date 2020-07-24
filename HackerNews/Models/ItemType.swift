//
//  ItemType.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation

enum ItemType: String, Decodable {
    case job
    case story
    case comment
    case poll
    case pollopt
}
