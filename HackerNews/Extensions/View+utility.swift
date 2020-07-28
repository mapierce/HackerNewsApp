//
//  View+utility.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

extension View {
    
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    func applyIf<T: View>(_ condition: @autoclosure () -> Bool, apply: (Self) -> T) -> AnyView {
        condition() ? apply(self).eraseToAnyView() : self.eraseToAnyView()
    }
    
}
