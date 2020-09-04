//
//  Menu.swift
//  HackerNews
//
//  Created by Matthew Pierce on 04/09/2020.
//

import SwiftUI

struct Menu: View {
    
    private struct Constants {
        
        static let buttonSize: CGFloat = 40
        static let doubleWidth: CGFloat = 16
        static let singleOffset = -50
        
    }
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var showMenu = false
    @ObservedObject var webStateModel: WebViewStateModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    ForEach(0..<MenuButtonItem.allCases.count) { index in
                        MenuButton(
                            systemImageName: MenuButtonItem.allCases[index].rawValue,
                            showMenu: $showMenu,
                            enabled: configure(enabled: MenuButtonItem.allCases[index])
                        ) {
                            handle(button: MenuButtonItem.allCases[index])
                        }
                        .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                        .offset(x: showMenu ? CGFloat((Constants.singleOffset * (index + 1))) : 0)
                        
                    }
                    BurgerButton {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }
                    .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                }
                Spacer().frame(width: Constants.doubleWidth)
            }
            Spacer().frame(height: Constants.doubleWidth)
        }
    }
    
    // MARK: - Private methods
    
    private func configure(enabled item: MenuButtonItem) -> Bool {
        switch item {
        case .back: return webStateModel.canGoBack
        case .forwards: return webStateModel.canGoForwards
        default: return true
        }
    }
    
    private func handle(button: MenuButtonItem) {
        switch button {
        case .home: mode.wrappedValue.dismiss()
        case .back: webStateModel.goBack.toggle()
        case .forwards: webStateModel.goForwards.toggle()
        case .reload: webStateModel.reload.toggle()
        default: return
        }
    }
    
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(webStateModel: WebViewStateModel())
    }
}
