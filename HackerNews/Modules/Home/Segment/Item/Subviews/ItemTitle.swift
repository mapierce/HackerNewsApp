//
//  ItemTitle.swift
//  HackerNews
//
//  Created by Matthew Pierce on 28/07/2020.
//

import SwiftUI

struct ItemTitle: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 16))
            .fontWeight(.semibold)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
    }
    
}

struct ItemTitle_Previews: PreviewProvider {
    static var previews: some View {
        ItemTitle(title: "some title")
    }
}
