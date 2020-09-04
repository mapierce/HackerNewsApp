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
    let enabled: Bool
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .background(Circle().foregroundColor(Color.white))
                    .shadow(color: Color.gray.opacity(showMenu ? 0.5 : 0), radius: 3)
                Image(systemName: systemImageName)
                    .font(.title2)
                    .foregroundColor(enabled ? Color("orangeColor") : Color.gray)
                    .shadow(radius: 0)
            }
            .onTapGesture {
                guard enabled else { return }
                action()
            }
        }
    }
    
}

struct MenuButton_Previews: PreviewProvider {
    
    @State static var showMenu = false
    
    static var previews: some View {
        MenuButton(systemImageName: "house", showMenu: $showMenu, enabled: true) {
            print("Tapped")
        }
        .frame(width: 50, height: 50)
    }
    
}
