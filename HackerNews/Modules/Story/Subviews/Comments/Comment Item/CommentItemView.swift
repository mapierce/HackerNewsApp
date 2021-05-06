//
//  CommentItemView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 26/10/2020.
//

import SwiftUI

struct CommentItemView: View {
    
    private struct Constants {
        
        static let loadingText = "Loading comment..."
        static let errorText = "Comment couldn't be loaded"
        
    }
    
    @StateObject var viewModel: CommentItemViewModel
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading: Text(Constants.loadingText)
                .fontWeight(.thin)
                .font(.system(size: 12))
                .italic()
            case .error: Text(Constants.errorText)
                .fontWeight(.thin)
                .font(.system(size: 12))
                .italic()
            case .complete:
                VStack(alignment: .leading) {
                    CommentMetadata(metadata: viewModel.metadata)
                    Text(viewModel.text)
                    if viewModel.commentCount > 0 {
                        CommentShowThreadButton(commentCount: viewModel.commentCount)
                    }
                }
                .padding()
            }
        }
    }
    
}

struct CommentItemView_Previews: PreviewProvider {
    static var previews: some View {
        CommentItemView(viewModel: CommentItemViewModel(commentId: 1))
    }
}
