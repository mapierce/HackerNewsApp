//
//  PollItem.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation

struct PollItem: ItemInterface {
    
    let uuid: Int
    let deleted: Bool?
    var type: ItemType { .poll }
    let by: String?
    let time: Int?
    let dead: Bool?
    let kids: [Int]?
    let parts: [Int]?
    let descendants: Int?
    let score: Int?
    let title: String
    let text: String?
    
    var tags: [TagTypes] {
        return (dead ?? false) ? [.dead, .poll] : [.poll]
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, deleted, by, time, dead, kids, parts, descendants, score, title, text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(Int.self, forKey: .id)
        deleted = try container.decodeIfPresent(Bool.self, forKey: .deleted)
        by = try container.decodeIfPresent(String.self, forKey: .by)
        time = try container.decodeIfPresent(Int.self, forKey: .time)
        dead = try container.decodeIfPresent(Bool.self, forKey: .dead)
        kids = try container.decodeIfPresent([Int].self, forKey: .kids)
        parts = try container.decode([Int]?.self, forKey: .parts)
        descendants = try container.decodeIfPresent(Int.self, forKey: .descendants)
        score = try container.decodeIfPresent(Int.self, forKey: .score)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "HackerNews: Poll"
        text = try container.decodeIfPresent(String.self, forKey: .text)
    }
    
}
