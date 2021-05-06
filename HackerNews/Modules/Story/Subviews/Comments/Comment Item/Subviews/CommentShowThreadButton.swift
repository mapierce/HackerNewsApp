//
//  CommentShowThreadButton.swift
//  HackerNews
//
//  Created by Matthew Pierce on 06/05/2021.
//

import SwiftUI

struct CommentShowThreadButton: View {
    
    private struct Constants {
        
        static let showCommentPrefix = "Show comments"
        static let hideCommentsText = "Hide comments"
        
    }
    
    @State var showComments = false
    let commentCount: Int
    
    var body: some View {
        Button {
            self.showComments.toggle()
        } label: {
            HStack {
                Spacer()
                Text(showComments ? Constants.hideCommentsText : "\(Constants.showCommentPrefix) (\(commentCount))")
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

struct CommentShowThreadButton_Previews: PreviewProvider {
    static var previews: some View {
        CommentShowThreadButton(commentCount: 1)
    }
}
