//
//  CommentItem.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation

struct CommentItem: ItemInterface {
    
    let uuid: Int
    let deleted: Bool?
    var type: ItemType { .comment }
    let by: String?
    let time: Int?
    let dead: Bool?
    let kids: [Int]?
    let parent: Int?
    let text: String?
    let title: String = "Comment"
    let score: Int? = nil
    let url: String? = nil
    
    var tags: [TagTypes] {
        return (dead ?? false) ? [.dead] : []
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, deleted, by, time, dead, kids, parent, text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(Int.self, forKey: .id)
        deleted = try container.decodeIfPresent(Bool.self, forKey: .deleted)
        by = try container.decodeIfPresent(String.self, forKey: .by)
        time = try container.decodeIfPresent(Int.self, forKey: .time)
        dead = try container.decodeIfPresent(Bool.self, forKey: .dead)
        kids = try container.decodeIfPresent([Int].self, forKey: .kids)
        parent = try container.decodeIfPresent(Int.self, forKey: .parent)
        text = try container.decodeIfPresent(String.self, forKey: .text)
    }
    
}
