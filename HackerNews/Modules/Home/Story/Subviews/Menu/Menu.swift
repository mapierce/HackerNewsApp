//
//  Menu.swift
//  HackerNews
//
//  Created by Matthew Pierce on 04/09/2020.
//

import SwiftUI

struct Menu: View {
    
    private struct Constants {
        
        static let houseImageName = "house"
        static let smallButtonSize: CGFloat = 40
        static let bigButtonSize: CGFloat = 50
        static let doubleWidth: CGFloat = 16
        static let singleOffset = -50
        static let largeOffset: CGFloat = -60
        
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
                    MenuButton(systemImageName: Constants.houseImageName, showMenu: Binding.constant(true), enabled: true) {
                        mode.wrappedValue.dismiss()
                    }
                    .frame(width: Constants.bigButtonSize, height: Constants.bigButtonSize)
                    .offset(y: showMenu ? CGFloat(Constants.singleOffset * (MenuButtonItem.allCases.count + 1)) : Constants.largeOffset)
                    ForEach(0..<MenuButtonItem.allCases.count) { index in
                        MenuButton(
                            systemImageName: MenuButtonItem.allCases[index].rawValue,
                            showMenu: $showMenu,
                            enabled: configure(enabled: MenuButtonItem.allCases[index])
                        ) {
                            handle(button: MenuButtonItem.allCases[index])
                        }
                        .frame(width: Constants.smallButtonSize, height: Constants.smallButtonSize)
                        .offset(y: showMenu ? CGFloat(Constants.singleOffset * (index + 1)) : 0)
                    }
                    BurgerButton {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }
                    .frame(width: Constants.bigButtonSize, height: Constants.bigButtonSize)
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
