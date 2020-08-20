//
//  TagTypes.swift
//  HackerNews
//
//  Created by Matthew Pierce on 20/08/2020.
//

import SwiftUI

enum TagTypes: String {
    
    case job
    case poll
    case dead
    
    var associatedColor: Color {
        switch self {
        case .poll: return Color("pollColor")
        case .job: return Color("jobColor")
        case .dead: return Color("deadColor")
        }
    }
    
}
