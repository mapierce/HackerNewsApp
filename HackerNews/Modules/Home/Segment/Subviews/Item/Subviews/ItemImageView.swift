//
//  ItemImageView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 20/08/2020.
//

import SwiftUI

struct ItemImageView: View {
    
    private struct Constants {
        
        static let imageFrameHeight: CGFloat = 155
        
    }
    
    var image: Image?
    
    var body: some View {
        if let loadedImage = image {
            loadedImage
                .resizable()
                .frame(height: Constants.imageFrameHeight)
        } else {
            ItemPlaceholderImage()
        }
    }
    
}

struct ItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        ItemImageView(image: nil)
    }
}
