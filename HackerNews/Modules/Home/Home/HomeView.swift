//
//  HomeView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import SwiftUI

struct HomeView: View {
    
    @State private var currentTabIndex = 0
    let viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SegmentedControl(selectedSegmentIndex: $currentTabIndex, segmentNames: viewModel.sections)
                TabView(selection: $currentTabIndex) {
                    ForEach(0..<viewModel.sections.count) { index in
                        SectionView()
                    }
                }
                .tabViewStyle(PageTabViewStyle())
            }
            .navigationBarTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
