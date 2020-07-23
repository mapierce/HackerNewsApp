//
//  Segment.swift
//  HackerNews
//
//  Created by Matthew Pierce on 23/07/2020.
//

import Foundation

enum Segment: String, CaseIterable {
    
    case top
    case new
    case ask
    case show
    case jobs
    
    var associatedPath: Path {
        switch self {
        case .top: return .top
        case .new: return .new
        case .ask: return .ask
        case .show: return .show
        case .jobs: return .jobs
        }
    }
    
}
