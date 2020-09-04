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
        
    }
    
    @ObservedObject var webStateModel: WebViewStateModel
    
    var body: some View {
        GeometryReader { geo in
            if webStateModel.progress < 1 {
                VStack {
                    Spacer()
                        .frame(height: 0)
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: Constants.height / 2)
                            .frame(height: Constants.height)
                        RoundedRectangle(cornerRadius: Constants.height / 2)
                            .fill(Color.green)
                            .frame(width: CGFloat(Double(geo.size.width) * webStateModel.progress), height: Constants.height)
                        Text("Loading...")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("loadingGrey"))
                            .offset(x: Constants.height / 2)
                    }
                    .padding(.horizontal)
                    .shadow(radius: 3)
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
