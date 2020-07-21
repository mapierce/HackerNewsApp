//
//  HomeView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                SegmentedControl()
                    .padding()
                Spacer()
                ScrollView {
                    HStack {
                        Text("One")
                        Text("Two")
                    }
                }
                Spacer()
            }.navigationBarTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
