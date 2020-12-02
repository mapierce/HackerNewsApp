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
        Text(viewModel.text)
    }
    
}

struct CommentItemView_Previews: PreviewProvider {
    static var previews: some View {
        CommentItemView(viewModel: CommentItemViewModel(commentId: 1))
    }
}
