//
//  ItemView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import SwiftUI
import Combine

struct ItemLoadableView: View {
    
    private struct Constants {
        
        static let placeholderTitle = "Placeholder title"
        static let placeholderMetadata = "Placeholder metadata"
        static let backgroundColorName = "itemBackgroundColor"
        
    }
    
    @Binding var itemState: ItemViewState
    
    var body: some View {
        Group {
            switch itemState {
            case .loading:
                VStack {
                    ItemImageView(image: nil, tags: [])
                    Spacer()
                    ItemDetailView(title: Constants.placeholderTitle, metadata: Constants.placeholderMetadata)
                    Spacer()
                }
                .background(Color(Constants.backgroundColorName))
                .redacted(reason: .placeholder)
            case .error:
                GeometryReader { geo in
                    ItemReloadView()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .background(Color(Constants.backgroundColorName))
                }
            case .complete(let item):
                VStack(alignment: .leading) {
                    ItemImageView(image: nil, tags: item.tags)
                    Spacer()
                    ItemDetailView(title: item.title, metadata: item.buildMetadata())
                    Spacer()
                }
                .background(Color(Constants.backgroundColorName))
            }
        }
    }
    
}

struct ItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            PreviewWrapper()
                .previewLayout(.fixed(width: 382, height: 240))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("iPhone 11 Pro Max")
            PreviewWrapper()
                .previewLayout(.fixed(width: 382, height: 240))
                .previewDisplayName("iPhone 11")
            PreviewWrapper()
                .previewLayout(.fixed(width: 343, height: 240))
                .previewDisplayName("iPhone 11 Pro")
        }
    }
    
    struct PreviewWrapper: View {
        
        var body: some View {
            ItemLoadableView(itemState: Binding.constant(.loading))
        }
        
        func setupRepository() -> ItemRespository {
            let cache = ItemCache()
            let story: StoryItem = load("story.json")
            let item: Item = .story(story)
            cache.write(item, for: item.id)
            return ItemRespository(cache: cache)
        }
        
        func load<T: Decodable>(_ filename: String) -> T {
            guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else { fatalError("Couln't load file") }
            let data: Data
            do {
                data = try Data(contentsOf: file)
            } catch {
                fatalError("Couldn't load contents of file")
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                fatalError("Couldn't parse file:\n\(error)")
            }
        }
        
    }
    
}
