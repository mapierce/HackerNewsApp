//
//  CustomSegmentedControl.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import SwiftUI

struct CustomSegmentedControl: View {
    
    private struct Constants {
        
        static let controlPadding: CGFloat = 4
        static let cornerRadius: CGFloat = 12
        static let segmentPadding: CGFloat = 8
        static let lineLimit = 1
        
    }
    
    @Binding var currentTabIndex: Int
    @State private var segmentSize: CGSize = .zero
    private let sections = ["All", "Top", "Ask", "Show", "Jobs"]
    
    var body: some View {
        ZStack(alignment: .leading) {
            ActiveSegmentView(segmentSize: $segmentSize, currentTabIndex: $currentTabIndex)
            HStack {
                ForEach(0..<self.sections.count, id:\.self) { index in
                    getSegmentView(for: index)
                }
            }
        }
        .padding(Constants.controlPadding)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
    
}

private extension CustomSegmentedControl {
    
    func getSegmentView(for index: Int) -> some View {
        guard index < sections.count else { return EmptyView().eraseToAnyView() }
        let isSelected = currentTabIndex == index
        return Text(sections[index])
            .foregroundColor(isSelected ? Color(.label) : Color(.secondaryLabel))
            .lineLimit(Constants.lineLimit)
            .padding(Constants.segmentPadding)
            .frame(minWidth: 0, maxWidth: .infinity)
            .modifier(SizeAwareModifier(viewSize: $segmentSize))
            .onTapGesture {
                onSectionTap(index)
            }
            .eraseToAnyView()
    }
    
    func onSectionTap(_ index: Int) {
        guard index < sections.count else { return }
        currentTabIndex = index
    }
    
}

struct CustomSegmentedControl_Previews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        
        @State private var currentTabIndex = 0
        
        var body: some View {
            CustomSegmentedControl(currentTabIndex: $currentTabIndex)
        }
    }
    
}
