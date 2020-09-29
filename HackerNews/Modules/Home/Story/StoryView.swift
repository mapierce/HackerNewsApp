//
//  StoryView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 25/08/2020.
//

import SwiftUI
import Snap

struct StoryView: View {
    
    @ObservedObject var viewModel: StoryViewModel
    @ObservedObject var webStateModel: WebViewStateModel
    @State private var drawerState: AppleMapsSnapState = .tiny
    
    var body: some View {
        VStack {
            switch viewModel.viewType {
            case .loading: ProgressView()
            case .web(let request):
                ZStack {
                    WebView(stateModel: webStateModel, request: request)
                        .edgesIgnoringSafeArea(.all)
                    Loader(webStateModel: webStateModel)
                    CommentListView(viewModel: CommentListViewModel(commentIds: viewModel.commentIds))
                    Menu(webStateModel: webStateModel)
                }
            case .native: Text("native")
            case .error: ErrorView { print("retry") }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetch()
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        
        var body: some View {
            StoryView(viewModel: StoryViewModel(itemId: 8863, itemRepository: setupRepository()), webStateModel: WebViewStateModel())
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
