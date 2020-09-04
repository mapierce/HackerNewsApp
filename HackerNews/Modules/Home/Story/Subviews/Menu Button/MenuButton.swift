//
//  MenuButton.swift
//  HackerNews
//
//  Created by Matthew Pierce on 03/09/2020.
//

import SwiftUI

struct MenuButton: View {
    
    let systemImageName: String
    @Binding var showMenu: Bool
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .background(Circle().foregroundColor(Color.white))
                    .shadow(color: Color.gray.opacity(showMenu ? 0.5 : 0), radius: 3)
                Image(systemName: systemImageName)
                    .font(.title2)
                    .foregroundColor(Color("orangeColor"))
                    .shadow(radius: 0)
            }
            .onTapGesture {
                action()
            }
        }
    }
    
}

struct MenuButton_Previews: PreviewProvider {
    
    @State static var showMenu = false
    
    static var previews: some View {
        MenuButton(systemImageName: "house", showMenu: $showMenu) {
            print("Tapped")
        }
        .frame(width: 50, height: 50)
    }
    
}
