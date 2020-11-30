//
//  ItemDetailView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 20/08/2020.
//

import SwiftUI

struct ItemDetailView: View {
    
    private struct Constants {
        
        static let singleSpace: CGFloat = 8
        static let doubleSpace: CGFloat = 16
        static let shareImageName = "square.and.arrow.up"
        static let iconSize: CGFloat = 24
        
    }
    
    let title: String
    let metadata: String
    let shareURL: String?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                ItemTitle(title: title)
                Spacer()
                ItemMetadata(metadata: metadata)
            }
            Spacer()
            VStack {
                Spacer()
                shareButton
                Spacer()
            }
            .font(.system(size: Constants.iconSize, weight: .light))
            .foregroundColor(.primary)
        }
        .padding(EdgeInsets(top: 0.0,
                            leading: Constants.doubleSpace,
                            bottom: Constants.singleSpace,
                            trailing: Constants.doubleSpace))
    }
    
    var shareButton: some View {
        Button(action: {
            guard let url = shareURL, let data = URL(string: url) else { return }
            let activityView = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityView, animated: true, completion: nil)
        }, label: {
            Image(systemName: Constants.shareImageName)
        })
    }
    
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(title: "Item title", metadata: "details below about item", shareURL: "https://www.apple.com")
            .previewLayout(.fixed(width: 343, height: 60))
            .previewDisplayName("iPhone 11 Pro Max")
    }
}
