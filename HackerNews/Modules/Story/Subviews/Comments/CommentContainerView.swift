//
//  CommentListView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 29/09/2020.
//

import SwiftUI
import Snap

struct CommentContainerView: View {
    
    private struct Constants {
        
        static let titleFontSize: CGFloat = 34
        static let title = "Comments"
        static let noCommentsPlaceholder = "No comments"
        
    }
    
    @ObservedObject var viewModel: CommentContainerViewModel
    @State private var drawerState: AppleMapsSnapState = .tiny
    
    var body: some View {
        SnapDrawer(
            state: $drawerState,
            large: .paddingToTop(16),
            medium: .fraction(0.5),
            tiny: .height(44),
            allowInvisible: false
        ) { state in
            VStack {
                HStack {
                    Text(Constants.title)
                        .font(.system(size: Constants.titleFontSize))
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                if let commentIds = viewModel.commentIds {
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(commentIds, id: \.self) { id in
                                CommentItemView(viewModel: CommentItemViewModel(commentId: id))
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
    }
    
}

struct CommentContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CommentContainerView(viewModel: CommentContainerViewModel(commentIds: nil))
    }
}
