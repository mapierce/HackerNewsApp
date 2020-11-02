//
//  ItemView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 13/10/2020.
//

import SwiftUI

struct ItemView: View {
    
    private struct Constants {
        
        static let placeholderTitle = "Placeholder title"
        static let placeholderMetadata = "Placeholder metadata"
        static let backgroundColorName = "itemBackgroundColor"
        
    }
    
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        if viewModel.error {
            ItemReloadView().onTapGesture {
                viewModel.reload()
            }
        } else {
            let storyView = StoryView(viewModel: StoryViewModel(itemId: viewModel.itemId), webStateModel: WebViewStateModel())
            NavigationLink(destination: storyView) {
                VStack {
                    ItemImageView(imageType: viewModel.image, tags: [])
                    Spacer()
                    ItemDetailView(
                        title: viewModel.item?.title ?? Constants.placeholderTitle,
                        metadata: viewModel.item?.buildMetadata() ?? Constants.placeholderMetadata
                    )
                    Spacer()
                }
            }
            .background(Color(Constants.backgroundColorName))
            .applyIf(viewModel.item == nil) {
                $0.redacted(reason: .placeholder)
            }
            .onAppear {
                viewModel.onAppeared()
            }
        }
    }
    
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView(item: nil, imageType: nil)
//    }
//}
