//
//  ItemView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 13/10/2020.
//

import SwiftUI

struct ItemView: View {
    
    private struct Constants {
        
        static let placeholderTitle = "Placeholder title"
        static let placeholderMetadata = "Placeholder metadata"
        static let backgroundColorName = "itemBackgroundColor"
        
    }
    
    let item: Item?
    let image: Image?
    
    var body: some View {
        VStack {
            ItemImageView(image: image, tags: item?.tags ?? [])
            Spacer()
            ItemDetailView(
                title: item?.title ?? Constants.placeholderTitle,
                metadata: item?.buildMetadata() ?? Constants.placeholderMetadata
            )
            Spacer()
        }
        .background(Color(Constants.backgroundColorName))
        .applyIf(item == nil) {
            $0.redacted(reason: .placeholder)
        }
    }
    
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: nil, image: nil)
    }
}
