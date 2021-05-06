//
//  ErrorView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 20/08/2020.
//

import SwiftUI

struct ErrorView: View {
    
    private struct Constants {
        
        static let errorImageName = "cactus"
        static let errorText = "Looks like there's nothing here! Maybe try loading again."
        static let retryButtonTitle = "Reload"
        static let horizontalPadding: CGFloat = 40
        
    }
    
    let action: (() -> Void)?
    
    var body: some View {
        VStack {
            Image(Constants.errorImageName)
            Text(Constants.errorText)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color(red: 126/255, green: 126/255, blue: 126/255))
            Button(action: {
                action?()
            }, label: {
                Text(Constants.retryButtonTitle)
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .padding(.horizontal, Constants.horizontalPadding)
                    .background(Capsule().foregroundColor(.blue))
            })
        }
    }
    
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(action: nil)
    }
}
