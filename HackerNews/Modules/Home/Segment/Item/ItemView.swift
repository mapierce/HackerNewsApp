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
        static let authorFontSize: CGFloat = 12
        static let emptyBookmarkImageName = "bookmark"
        static let emptyBellImageName = "bell"
        static let backgroundColorName = "itemBackgroundColor"
        
    }
    
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        if let item = viewModel.item {
            VStack(alignment: .leading) {
                itemImage
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        itemTitle
                        Spacer()
                            .frame(height: Constants.singleSpace)
                        itemAuthor
                    }
                    .padding(.leading, Constants.doubleSpace)
                    Spacer()
                    VStack {
                        bookmarkButton
                        bellButton
                    }
                    .padding(.trailing, Constants.doubleSpace)
                }
                Spacer()
            }
            .background(Color(Constants.backgroundColorName))
        } else {
            ProgressView()
        }
    }
    
    var itemImage: some View {
        Image("orangeItemPlaceholder")
            .resizable()
            .scaledToFill()
            .frame(height: Constants.imageFrameHeight)
            .clipped()
    }
    
    var itemTitle: some View {
        Text("It's easier to manage four people than one person")
            .font(.system(size: Constants.doubleSpace))
            .fontWeight(.semibold)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
    }
    
    var itemAuthor: some View {
        Text("104 points by chesterarthur 2 hours ago")
            .fontWeight(.thin)
            .font(.system(size: Constants.authorFontSize))
            .italic()
            .lineLimit(1)
    }
    
    var bookmarkButton: some View {
        Button(action: {
            print("Bookmark tapped")
        }) {
            Image(systemName: Constants.emptyBookmarkImageName)
                .font(Font.title.weight(.light))
                .foregroundColor(.primary)
        }
        .padding(.bottom, Constants.doubleSpace)
    }
    
    var bellButton: some View {
        Button(action: {
            print("Bookmark tapped")
        }) {
            Image(systemName: Constants.emptyBellImageName)
                .font(Font.title.weight(.light))
                .foregroundColor(.primary)
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
            ItemView(viewModel: ItemViewModel(repository: setupRepository(), itemId: 8863))
        }
        
        func setupRepository() -> ItemRespository {
            let cache = ItemCache()
            let story: StoryItem = load("story.json")
            let item: Item = .story(story)
            cache.write(item)
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
