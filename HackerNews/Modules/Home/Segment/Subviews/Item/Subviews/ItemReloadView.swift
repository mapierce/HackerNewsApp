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
        static let backgroundColorName = "itemBackgroundColor"
        static let retryText = "Looks like we had some trouble loading that story, tap to retry"
        static let imageHeight: CGFloat = 50
        static let paddingHeight: CGFloat = 66.5
        static let spacerHeight: CGFloat = 20
        static let doubleSpace: CGFloat = 16
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer().frame(height: Constants.paddingHeight)
                Image(systemName: Constants.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.imageHeight)
                Spacer().frame(height: Constants.spacerHeight)
                HStack {
                    Spacer().frame(width: Constants.doubleSpace)
                    Text(Constants.retryText)
                        .italic()
                        .font(.caption)
                        .multilineTextAlignment(.center)
                    Spacer().frame(width: Constants.doubleSpace)
                }
                Spacer().frame(height: Constants.paddingHeight)
            }
            Spacer()
        }
        .foregroundColor(.gray)
        .background(Color(Constants.backgroundColorName))
    }
    
}

struct ItemReloadView_Previews: PreviewProvider {
    static var previews: some View {
        ItemReloadView()
            .previewLayout(.fixed(width: 343, height: 215))
            .previewDisplayName("iPhone 11 Pro Max")
    }
}
