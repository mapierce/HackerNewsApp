//
//  HomeView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import SwiftUI

struct HomeView: View {
    
    @State private var currentTabIndex = 0
    private let sections = ["Top", "All", "Ask", "Show", "Jobs"]
    
    var body: some View {
        NavigationView {
            VStack {
                SegmentedControl(selectedSegmentIndex: $currentTabIndex)
                TabView(selection: $currentTabIndex) {
                    ForEach(0..<sections.count) { index in
                        ContainerView(text: sections[index])
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
