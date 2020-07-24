//
//  StoryItem.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation

struct StoryItem: ItemInterface {
    
    let id: Int
    let deleted: Bool?
    var type: ItemType { .story }
    let by: String?
    let time: Int?
    let dead: Bool?
    let kids: [Int]?
    let descendants: Int?
    let score: Int?
    let title: String?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, deleted, by, time, dead, kids, descendants, score, title, url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        deleted = try container.decodeIfPresent(Bool.self, forKey: .deleted)
        by = try container.decodeIfPresent(String.self, forKey: .by)
        time = try container.decodeIfPresent(Int.self, forKey: .time)
        dead = try container.decodeIfPresent(Bool.self, forKey: .dead)
        kids = try container.decodeIfPresent([Int].self, forKey: .kids)
        descendants = try container.decodeIfPresent(Int.self, forKey: .descendants)
        score = try container.decodeIfPresent(Int.self, forKey: .score)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        url = try container.decodeIfPresent(String.self, forKey: .url)
    }
    
}
