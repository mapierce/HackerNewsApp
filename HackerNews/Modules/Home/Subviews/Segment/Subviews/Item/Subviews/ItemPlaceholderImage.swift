//
//  ItemPlaceholderImage.swift
//  HackerNews
//
//  Created by Matthew Pierce on 18/08/2020.
//

import SwiftUI

struct ItemPlaceholderImage: View {
    
    private struct Constants {
        
        static let imageFrameHeight: CGFloat = 155
        static let placeholderFrameHeight: CGFloat = 40
        static let placeholderImageName = "imagePlaceholder"
        static let loadingImageText = "Loading image..."
        
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Image(Constants.placeholderImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: Constants.placeholderFrameHeight)
                Text(Constants.loadingImageText)
                    .font(.caption)
            }
            .frame(height: Constants.imageFrameHeight)
            Spacer()
        }
    }
    
}

struct ItemPlaceholderImage_Previews: PreviewProvider {
    static var previews: some View {
        ItemPlaceholderImage()
    }
}
