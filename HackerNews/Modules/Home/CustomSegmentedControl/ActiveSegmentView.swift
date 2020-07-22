//
//  ActiveSegmentView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

struct ActiveSegmentView: View {
    
    @Binding var segmentSize: CGSize
    @Binding var currentTabIndex: Int
    
    var body: some View {
        guard segmentSize != .zero else { return EmptyView().eraseToAnyView() }
        return RoundedRectangle(cornerRadius: 12)
            .foregroundColor(Color(.tertiarySystemBackground))
            .shadow(color: Color.black.opacity(2), radius: 4)
            .frame(width: segmentSize.width, height: segmentSize.height)
            .offset(x: computeActiveSegmentHorizontalOffset(), y: 0)
//            .animation(.linear(duration: 0.2))
            .eraseToAnyView()
    }
    
}

private extension ActiveSegmentView {
    
    func computeActiveSegmentHorizontalOffset() -> CGFloat {
        CGFloat(currentTabIndex) * (segmentSize.width + 8)
    }
    
}

struct ActiveSegmentView_Previews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        
        @State private var currentTabIndex = 0
        @State private var segmentSize = CGSize(width: 60, height: 30)
        
        var body: some View {
            ActiveSegmentView(segmentSize: $segmentSize, currentTabIndex: $currentTabIndex)
        }
    }
    
}
