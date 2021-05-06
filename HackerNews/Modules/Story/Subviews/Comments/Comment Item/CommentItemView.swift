//
//  CommentItemView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 26/10/2020.
//

import SwiftUI

struct CommentItemView: View {
    
    @StateObject var viewModel: CommentItemViewModel
    @State var showComments = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.metadata)
                .fontWeight(.thin)
                .font(.system(size: 12))
                .italic()
            Text(viewModel.text)
            if viewModel.commentCount > 0 {
                Button {
                    self.showComments.toggle()
                } label: {
                    HStack {
                        Spacer()
                        Text(showComments ? "Hide comments" : "Show comments (\(viewModel.commentCount))")
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(showComments ? 180 : 0))
                            .animation(.spring())
                        Spacer()
                    }
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                }
                .padding(10)
                .background(
                    Rectangle()
                        .foregroundColor(Color.black.opacity(0.2))
                        .cornerRadius(5)
                )
            }
        }
        .padding()
    }
    
}

struct CommentItemView_Previews: PreviewProvider {
    static var previews: some View {
        CommentItemView(viewModel: CommentItemViewModel(commentId: 1))
    }
}
