//
//  View+erasure.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

extension View {
    
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
}
