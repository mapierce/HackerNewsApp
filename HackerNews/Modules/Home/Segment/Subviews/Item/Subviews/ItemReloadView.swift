//
//  ItemReloadView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 20/08/2020.
//

import SwiftUI

struct ItemReloadView: View {
    
    private struct Constants {
        
        static let imageName = "arrow.clockwise"
        static let retryText = "Looks like we had some trouble loading that story, tap to retry"
        static let imageHeight: CGFloat = 50
        static let spacerHeight: CGFloat = 20
    }
    
    var body: some View {
        VStack {
            Image(systemName: "arrow.clockwise")
                .resizable()
                .foregroundColor(Color.primary)
                .scaledToFit()
                .frame(width: Constants.imageHeight)
            Spacer().frame(height: Constants.spacerHeight)
            Text(Constants.retryText)
                .italic()
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
    
}

struct ItemReloadView_Previews: PreviewProvider {
    static var previews: some View {
        ItemReloadView()
            .previewLayout(.fixed(width: 343, height: 215))
            .previewDisplayName("iPhone 11 Pro Max")
    }
}
