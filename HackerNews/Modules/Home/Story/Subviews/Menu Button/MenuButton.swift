//
//  MenuButton.swift
//  HackerNews
//
//  Created by Matthew Pierce on 03/09/2020.
//

import SwiftUI

struct MenuButton: View {
    
    let systemImageName: String
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .strokeBorder(Color("orangeColor"), lineWidth: 2)
                    .background(Circle().foregroundColor(Color.white))
                    .shadow(radius: 3)
                Image(systemName: systemImageName)
                    .font(.title2)
                    .foregroundColor(Color("orangeColor"))
            }
            .onTapGesture {
                action()
            }
        }
    }
    
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(systemImageName: "house") {
            print("Tapped")
        }
        .frame(width: 50, height: 50)
    }
}
