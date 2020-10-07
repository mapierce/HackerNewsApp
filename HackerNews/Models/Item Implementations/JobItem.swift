//
//  JobItem.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation

struct JobItem: ItemInterface {
    
    let uuid: Int
    let deleted: Bool?
    var type: ItemType { .job }
    let by: String?
    let time: Int?
    let dead: Bool?
    let kids: [Int]?
    let text: String?
    let url: String?
    let title: String
    let score: Int? = nil
    
    var tags: [TagTypes] {
        return (dead ?? false) ? [.dead, .job] : [.job]
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, deleted, by, time, dead, kids, text, url, title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(Int.self, forKey: .id)
        deleted = try container.decodeIfPresent(Bool.self, forKey: .deleted)
        by = try container.decodeIfPresent(String.self, forKey: .by)
        time = try container.decodeIfPresent(Int.self, forKey: .time)
        dead = try container.decodeIfPresent(Bool.self, forKey: .dead)
        kids = try container.decodeIfPresent([Int].self, forKey: .kids)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "HackerNews: Job"
    }
    
}
