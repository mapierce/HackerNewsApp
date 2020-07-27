//
//  Item.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation

@dynamicMemberLookup
enum Item: Decodable, Identifiable {
    
    var id: Int {
        self.uuid
    }
    
    case job(JobItem)
    case story(StoryItem)
    case comment(CommentItem)
    case poll(PollItem)
    case pollopt(PollOptionItem)
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ItemType.self, forKey: .type)
        switch type {
        case .job: self = .job(try JobItem(from: decoder))
        case .story: self = .story(try StoryItem(from: decoder))
        case .comment: self = .comment(try CommentItem(from: decoder))
        case .poll: self = .poll(try PollItem(from: decoder))
        case .pollopt: self = .pollopt(try PollOptionItem(from: decoder))
        }
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<ItemInterface, T>) -> T {
        switch self {
        case .job(let jobItem): return jobItem[keyPath: keyPath]
        case .story(let storyItem): return storyItem[keyPath: keyPath]
        case .comment(let commentItem): return commentItem[keyPath: keyPath]
        case .poll(let pollItem): return pollItem[keyPath: keyPath]
        case .pollopt(let polloptItem): return polloptItem[keyPath: keyPath]
        }
    }
    
}
