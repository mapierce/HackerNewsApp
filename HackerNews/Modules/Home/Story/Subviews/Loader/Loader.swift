//
//  Loader.swift
//  HackerNews
//
//  Created by Matthew Pierce on 04/09/2020.
//

import SwiftUI

struct Loader: View {
    
    private struct Constants {
        
        static let height: CGFloat = 20
        static let quadrupleSpace: CGFloat = 32
        static let loadingText = "Loading..."
        static let loadingTextColor = "loadingGrey"
        
    }
    
    @ObservedObject var webStateModel: WebViewStateModel
    
    var body: some View {
        GeometryReader { geo in
            if webStateModel.progress < 1 {
                VStack {
                    Spacer()
                        .frame(height: Constants.quadrupleSpace)
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: Constants.height / 2)
                            .fill(Color.white)
                            .frame(height: Constants.height)
                            .shadow(radius: 3)
                        RoundedRectangle(cornerRadius: Constants.height / 2)
                            .fill(Color.green)
                            .frame(width: CGFloat(Double(geo.size.width) * webStateModel.progress), height: Constants.height)
                        Text(Constants.loadingText)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(Constants.loadingTextColor))
                            .offset(x: Constants.height / 2)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
            }
        }
    }
    
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader(webStateModel: WebViewStateModel())
    }
}
