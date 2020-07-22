//
//  BaseModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import Foundation

protocol BaseModel: Decodable {
    
    var id: Int { get }
    var deleted: Bool? { get }
    var type: ItemType { get }
    var by: String? { get }
    var time: Int? { get }
    var dead: Bool? { get }
    var kids: [Int]? { get }
    
}

enum ItemType: String, Decodable {
    case job
    case story
    case comment
    case poll
    case pollopt
}
