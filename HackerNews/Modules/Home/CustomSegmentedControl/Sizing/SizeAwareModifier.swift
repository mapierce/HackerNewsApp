//
//  SizeAwareModifier.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

struct SizeAwareModifier: ViewModifier {
    
    @Binding var viewSize: CGSize

    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self) { viewSize = viewSize != $0 ? $0 : viewSize }
    }
    
}
