//
//  SegmentView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

struct SegmentView: View {
    
    private struct Constants {
        
        static let cornerRadius: CGFloat = 15
        static let shadowRadius: CGFloat = 3
        
    }
    
    @ObservedObject var viewModel: SegmentViewModel
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading: ProgressView()
            case .error: ErrorView { viewModel.retry() }
            case .complete:
                ScrollView {
                    LazyVStack {
                        ForEach(0..<viewModel.itemIds.count, id: \.self) { index in
                            Group {
                                switch viewModel.items[index] {
                                case .loading: ItemView(item: nil, image: nil)
                                case .complete(let item):
                                    NavigationLink(destination: StoryView(
                                                    viewModel: StoryViewModel(itemId: viewModel.itemIds[index]),
                                                    webStateModel: WebViewStateModel())
                                    ) {
                                        ItemView(item: item, image: viewModel.images[index])
                                            .onAppear { viewModel.cellAppeared(at: index) }
                                            .onDisappear { viewModel.cellDisappeared(at: index) }
                                    }
                                case .error:
                                    ItemReloadView()
                                        .onTapGesture { viewModel.reloadItem(at: index) }
                                }
                            }
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
    
}

struct SegmentView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentView(viewModel: SegmentViewModel(segment: .top))
    }
}
