//
//  CommentListView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 29/09/2020.
//

import SwiftUI
import Snap

struct CommentListView: View {
    
    @ObservedObject var viewModel: CommentListViewModel
    @State private var drawerState: AppleMapsSnapState = .tiny
    
    var body: some View {
        SnapDrawer(state: $drawerState, large: .paddingToTop(16), medium: .fraction(0.45), tiny: .height(44), allowInvisible: false) { state in
            VStack {
                HStack {
                    Text("Comments")
                        .font(.system(size: 34))
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                if let commentIds = viewModel.commentIds {
                    ScrollView {
                        LazyVStack {
                            ForEach(commentIds, id: \.self) { id in
                                CommentItemView(viewModel: CommentItemViewModel(commentId: id))
                            }
                        }
                    }
                } else {
                    Spacer()
                    Text("No Comments")
                    Spacer()
                }
            }
        }
    }
    
}

struct CommentListView_Previews: PreviewProvider {
    static var previews: some View {
        CommentListView(viewModel: CommentListViewModel(commentIds: nil))
    }
}
