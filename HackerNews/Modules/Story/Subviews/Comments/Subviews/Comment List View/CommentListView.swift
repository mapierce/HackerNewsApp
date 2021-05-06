//
//  CommentListView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 06/05/2021.
//

import SwiftUI

struct CommentListView: View {
    
    private struct Constants {
        
        static let noCommentsPlaceholder = "No comments"
        
    }
    
    let commentIds: [Int]?
    let nestingLevel: Int
    
    var body: some View {
        if let commentIds = commentIds {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(commentIds, id: \.self) { id in
                        CommentItemView(viewModel: CommentItemViewModel(commentId: id), nestingLevel: nestingLevel)
                    }
                }
            }
        } else {
            Spacer()
            Text(Constants.noCommentsPlaceholder)
            Spacer()
        }
    }
    
}

struct CommentListView_Previews: PreviewProvider {
    static var previews: some View {
        CommentListView(commentIds: nil, nestingLevel: 0)
    }
}
