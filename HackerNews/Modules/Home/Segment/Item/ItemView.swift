//
//  ItemView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import SwiftUI

struct ItemView: View {
    
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        if let item = viewModel.item {
            Text("\(item.by ?? "No author")")
        } else {
            ProgressView()
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper().previewLayout(.fixed(width: 300, height: 300))
    }
    
    struct PreviewWrapper: View {
        
        var body: some View {
            ItemView(viewModel: ItemViewModel(repository: setupRepository(), itemId: 8863))
        }
        
        func setupRepository() -> ItemRespository {
            let cache = ItemCache()
            let story: StoryItem = load("story.json")
            let item: Item = .story(story)
            cache.write(item)
            return ItemRespository(cache: cache)
        }
        
    }
    
}
