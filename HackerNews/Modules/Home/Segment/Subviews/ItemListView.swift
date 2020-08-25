//
//  ItemListView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 20/08/2020.
//

import SwiftUI

struct ItemListView: View {
    
    private struct Constants {
        
        static let cornerRadius: CGFloat = 15
        static let shadowRadius: CGFloat = 3
        
    }
    
    let itemIds: [Int]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(itemIds, id: \.self) { id in
                    NavigationLink(destination: StoryView(viewModel: StoryViewModel(itemId: id)) ) {
                        ItemView(viewModel: ItemViewModel(itemId: id))
                            .cornerRadius(Constants.cornerRadius)
                            .padding()
                            .shadow(radius: Constants.shadowRadius)
                            .foregroundColor(Color.primary)
                    }
                }
            }
        }
    }
    
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(itemIds: [])
    }
}
