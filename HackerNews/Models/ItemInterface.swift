//
//  ItemInterface.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation

protocol ItemInterface: Decodable {
    
    var uuid: Int { get }
    var deleted: Bool? { get }
    var type: ItemType { get }
    var by: String? { get }
    var time: Int? { get }
    var dead: Bool? { get }
    var kids: [Int]? { get }
    var title: String { get }
    var tags: [TagTypes] { get }
    var score: Int? { get }
    
}
