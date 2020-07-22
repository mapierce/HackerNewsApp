//
//  SegmentedControl.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

struct SegmentedControl: View {
    
    @Binding var selectedSegmentIndex: Int
    private let segmentNames = ["All", "Top", "Ask", "Show", "Jobs"]
    
    var body: some View {
        Picker("Home Section Picker", selection: $selectedSegmentIndex) {
            ForEach(0..<segmentNames.count) { index in
                Text(segmentNames[index]).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}

struct SegmentedControl_Previews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        
        @State private var selectedSegmentIndex = 0
        
        var body: some View {
            SegmentedControl(selectedSegmentIndex: $selectedSegmentIndex)
        }
    }
    
}
