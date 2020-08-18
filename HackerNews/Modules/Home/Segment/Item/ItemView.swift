//
//  ItemView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import SwiftUI

struct ItemView: View {
    
    private struct Constants {
        
        static let imageFrameHeight: CGFloat = 155
        static let singleSpace: CGFloat = 8
        static let doubleSpace: CGFloat = 16
        static let iconSize: CGFloat = 20
        static let emptyBookmarkImageName = "bookmark"
        static let emptyBellImageName = "bell"
        static let backgroundColorName = "itemBackgroundColor"
        
    }
    
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let loadedImage = viewModel.image {
                loadedImage
                    .resizable()
                    .frame(height: Constants.imageFrameHeight)
            } else {
                Text("Loading image").frame(height: Constants.imageFrameHeight)
            }
            Spacer()
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    ItemTitle(title: viewModel.title)
                    Spacer()
                    ItemMetadata(metadata: viewModel.metadata)
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
            Spacer()
        }
        .background(Color(Constants.backgroundColorName))
        .applyIf(viewModel.loading) {
            $0.redacted(reason: .placeholder)
        }
        .onAppear {
            viewModel.fetch()
        }
        .onDisappear {
            viewModel.cancel()
        }
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
