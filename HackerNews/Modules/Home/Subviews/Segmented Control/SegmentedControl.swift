//
//  SegmentedControl.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

struct SegmentedControl: View {
    
    private struct Constants {
        
        static let padding: CGFloat = 16
        
    }
    
    @Binding var selectedSegmentIndex: Int
    let segments: [Segment]
    
    var body: some View {
        Picker("Home Section Picker", selection: $selectedSegmentIndex) {
            ForEach(0..<segments.count) { index in
                Text(segments[index].rawValue.capitalizingFirstLetter()).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(EdgeInsets(top: Constants.padding, leading: Constants.padding, bottom: 0, trailing: Constants.padding))
    }
    
}

struct SegmentedControl_Previews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        
        @State private var selectedSegmentIndex = 0
        private let segments = Segment.allCases
        
        var body: some View {
            SegmentedControl(selectedSegmentIndex: $selectedSegmentIndex, segments: segments)
        }
    }
    
}
