//
//  SegmentedControl.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import SwiftUI

struct SegmentedControl: View {
    
    @State private var currentSectionIndex = 0
    private let sections = ["All", "Top", "Ask", "Show", "Jobs"]
    
    var body: some View {
        VStack {
            Picker(selection: $currentSectionIndex, label: Text("Something")) {
                ForEach(0..<sections.count) { index in
                    Text(self.sections[index]).tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct SegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControl()
    }
}
