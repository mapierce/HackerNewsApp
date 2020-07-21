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
                GeometryReader { geo in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            AllView().frame(width: geo.size.width, height: geo.size.height)
                            TopView().frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                }
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
