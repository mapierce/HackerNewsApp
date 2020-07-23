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
                SegmentedControl(selectedSegmentIndex: $currentTabIndex, segments: viewModel.segments)
                TabView(selection: $currentTabIndex) {
                    ForEach(0..<viewModel.segments.count) { index in
                        ItemView(viewModel: ItemViewModel(segment: viewModel.segments[index]) )
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
