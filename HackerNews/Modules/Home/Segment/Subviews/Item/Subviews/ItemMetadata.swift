//
//  ItemMetadata.swift
//  HackerNews
//
//  Created by Matthew Pierce on 28/07/2020.
//

import SwiftUI

struct ItemMetadata: View {
    
    let metadata: String
    
    var body: some View {
        Text(metadata)
            .fontWeight(.thin)
            .font(.system(size: 12))
            .italic()
            .lineLimit(1)
    }
    
}

struct ItemMetadata_Previews: PreviewProvider {
    static var previews: some View {
        ItemMetadata(metadata: "By so and so a while ago")
    }
}
