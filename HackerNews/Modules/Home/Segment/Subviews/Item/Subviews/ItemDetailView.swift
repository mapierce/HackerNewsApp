//
//  ItemDetailView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 20/08/2020.
//

import SwiftUI

struct ItemDetailView: View {
    
    private struct Constants {
        
        static let singleSpace: CGFloat = 8
        static let doubleSpace: CGFloat = 16
        static let emptyBookmarkImageName = "bookmark"
        static let emptyBellImageName = "bell"
        static let iconSize: CGFloat = 20
        
    }
    
    let title: String
    let metadata: String
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                ItemTitle(title: title)
                Spacer()
                ItemMetadata(metadata: metadata)
            }
            Spacer()
            VStack {
                bookmarkButton
                Spacer()
                bellButton
            }
            .font(.system(size: Constants.iconSize, weight: .light))
            .foregroundColor(.primary)
        }
        .padding(EdgeInsets(top: 0.0,
                            leading: Constants.doubleSpace,
                            bottom: Constants.singleSpace,
                            trailing: Constants.doubleSpace))
    }
    
    var bookmarkButton: some View {
        Button(action: {
            print("Bookmark tapped")
        }) {
            Image(systemName: Constants.emptyBookmarkImageName)
        }
    }
    
    var bellButton: some View {
        Button(action: {
            print("Bell tapped")
        }) {
            Image(systemName: Constants.emptyBellImageName)
        }
    }
    
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(title: "Item title", metadata: "details below about item")
            .previewLayout(.fixed(width: 343, height: 60))
            .previewDisplayName("iPhone 11 Pro Max")
    }
}
