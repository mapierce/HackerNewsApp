//
//  StoryView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 25/08/2020.
//

import SwiftUI
import Snap

struct StoryView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var viewModel: StoryViewModel
    @ObservedObject var stateModel: WebViewStateModel
    @State private var showMenu = false
    private var menuClicked: Bool {
        return showMenu
    }
    
    var body: some View {
        VStack {
            switch viewModel.viewType {
            case .loading: ProgressView()
            case .web(let request):
                ZStack {
                    WebView(stateModel: stateModel, request: request)
                    if stateModel.progress < 1 {
                        VStack {
                            ProgressView("", value: stateModel.progress, total: 1)
                                .offset(y: -18.0)
                            Spacer()
                        }
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ZStack {
                                ForEach(0..<MenuButtonItem.allCases.count) { index in
                                    MenuButton(systemImageName: MenuButtonItem.allCases[index].rawValue, showMenu: $showMenu) {
                                        handle(button: MenuButtonItem.allCases[index])
                                    }
                                    .frame(width: 40, height: 40)
                                    .offset(x: showMenu ? CGFloat((-50 * (index + 1))) : 0)
                                    
                                }
                                BurgerButton {
                                    withAnimation {
                                        showMenu.toggle()
                                    }
                                }
                                .frame(width: 40, height: 40)
                            }
                            Spacer().frame(width: 16)
                        }
                        Spacer().frame(height: 16)
                    }
                }
            case .native: Text("native")
            case .error: ErrorView { print("retry") }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetch()
        }
    }
    
    private func handle(button: MenuButtonItem) {
        switch button {
        case .home: mode.wrappedValue.dismiss()
        case .bookmark: return
        case .reminder: return
        case .back: return
        case .forwards: return
        case .reload: return
        }
    }
    
}

struct StoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        
        var body: some View {
            StoryView(viewModel: StoryViewModel(itemId: 8863, itemRepository: setupRepository()), stateModel: WebViewStateModel())
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
