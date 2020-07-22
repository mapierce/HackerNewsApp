//
//  BackgroundGeometryReader.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

struct BackgroundGeometryReader: View {
    
    var body: some View {
        GeometryReader { geo in
            Color.clear.preference(key: SizePreferenceKey.self, value: geo.size)
        }
    }
    
}
