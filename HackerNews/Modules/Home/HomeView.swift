//
//  HomeView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import SwiftUI

struct HomeView: View {
    
    @State private var currentTabIndex = 0
    
    var body: some View {
        NavigationView {
            VStack {
                SegmentedControl(currentTabIndex: $currentTabIndex)
                    .padding()
                Spacer()
                TabView(selection: $currentTabIndex) {
                    AllView().tag(0)
                    TopView().tag(1)
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
