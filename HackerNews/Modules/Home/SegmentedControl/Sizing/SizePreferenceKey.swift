//
//  SizePreferenceKey.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
    
}
