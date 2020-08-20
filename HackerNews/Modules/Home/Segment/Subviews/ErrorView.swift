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
        
    }
    
    let action: (() -> Void)?
    
    var body: some View {
        Image(Constants.errorImageName)
        Text(Constants.errorText)
            .font(.title2)
            .fontWeight(.semibold)
            .lineLimit(nil)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(Color(red: 126/255, green: 126/255, blue: 126/255))
        Button(Constants.retryButtonTitle) {
            action?()
        }
        .foregroundColor(.white)
        .font(.title2)
        .padding()
        .padding(.horizontal, 40)
        .background(Capsule().foregroundColor(.blue))
    }
    
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(action: nil)
    }
}
