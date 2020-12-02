//
//  CommentItemView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 26/10/2020.
//

import SwiftUI

struct CommentItemView: View {
    
    @StateObject var viewModel: CommentItemViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.metadata)
                .fontWeight(.thin)
                .font(.system(size: 12))
                .italic()
            Text(viewModel.text)
            Rectangle()
                .frame(height: 0.5)
                .background(Color.secondary)
        }
        .padding()
    }
    
}

struct CommentItemView_Previews: PreviewProvider {
    static var previews: some View {
        CommentItemView(viewModel: CommentItemViewModel(commentId: 1))
    }
}
