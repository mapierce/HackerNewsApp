//
//  CommentMetadata.swift
//  HackerNews
//
//  Created by Matthew Pierce on 06/05/2021.
//

import SwiftUI

struct CommentMetadata: View {
    
    let metadata: String
    
    var body: some View {
        Text(metadata)
            .fontWeight(.thin)
            .font(.system(size: 12))
            .italic()
    }
    
}

struct CommentMetadata_Previews: PreviewProvider {
    static var previews: some View {
        CommentMetadata(metadata: "Metadata")
    }
}
