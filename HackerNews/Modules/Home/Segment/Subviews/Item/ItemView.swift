//
//  ItemView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import SwiftUI

struct ItemView: View {
    
    private struct Constants {
        
        static let backgroundColorName = "itemBackgroundColor"
        
    }
    
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ItemImageView(image: viewModel.image, tags: viewModel.tags)
                Spacer()
                ItemDetailView(title: viewModel.title, metadata: viewModel.metadata)
                Spacer()
            }
            .applyIf(viewModel.viewState == .loading) {
                $0.redacted(reason: .placeholder)
            }
            if viewModel.viewState == .error {
                GeometryReader { geo in
                    ItemReloadView()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .background(Color(Constants.backgroundColorName))
                        .onTapGesture {
                            viewModel.fetch()
                        }
                }
            }
        }
        .background(Color(Constants.backgroundColorName))
        .onAppear {
            viewModel.fetch()
        }
        .onDisappear {
            viewModel.cancel()
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
            ItemView(viewModel: ItemViewModel(itemRepository: setupRepository(), itemId: 8863))
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
