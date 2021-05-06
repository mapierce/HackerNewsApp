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
    @State private var showComments = false
    let nestingLevel: Int
    
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
                HStack {
                    Rectangle()
                        .frame(width: 0.5)
                        .background(Color.secondary)
                    VStack(alignment: .leading) {
                        CommentMetadata(metadata: viewModel.metadata)
                        Text(viewModel.text)
                        if let commentIds = viewModel.commentIds, let commentCount = commentIds.count, commentCount > 0 {
                            CommentShowThreadButton(showComments: $showComments, commentCount: commentCount)
                            if showComments {
                                CommentListView(commentIds: commentIds, nestingLevel: nestingLevel + 1)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
}

struct CommentItemView_Previews: PreviewProvider {
    static var previews: some View {
        CommentItemView(viewModel: CommentItemViewModel(commentId: 1), nestingLevel: 0)
    }
}
