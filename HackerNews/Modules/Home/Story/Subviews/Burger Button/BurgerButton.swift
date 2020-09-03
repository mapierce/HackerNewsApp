//
//  BurgerButton.swift
//  HackerNews
//
//  Created by Matthew Pierce on 03/09/2020.
//

import SwiftUI

struct BurgerButton: View {
    
    @State private var collapse = false
    @State private var hide = false
    @State private var fanOut = false
    
    let action: () -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle().fill(Color("orangeColor"))
                VStack(alignment: .center, spacing: 0) {
                    Line(size: geo.size)
                        .offset(y: collapse ? geo.size.height * 0.18 : 0)
                        .opacity(hide ? 0.0 : 1.0)
                    Spacer().frame(height: geo.size.height * 0.1)
                    ZStack {
                        Line(size: geo.size)
                            .rotationEffect(.degrees(fanOut ? 45 : 0))
                        Line(size: geo.size)
                            .rotationEffect(.degrees(fanOut ? -45 : 0))
                    }
                    Spacer().frame(height: geo.size.height * 0.1)
                    Line(size: geo.size)
                        .offset(y: collapse ? geo.size.height * -0.18 : 0)
                        .opacity(hide ? 0.0 : 1.0)
                }
            }
            .onTapGesture {
                animate()
                action()
            }
        }
    }
    
    private func animate() {
        let animation = Animation.easeInOut(duration: 0.3)
        let currentCollapse = collapse
        withAnimation(animation) {
            currentCollapse ? fanOut.toggle() : collapse.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            hide.toggle()
            withAnimation(animation) {
                currentCollapse ? collapse.toggle() : fanOut.toggle()
            }
        }
    }
    
}

struct Line: View {
    
    let size: CGSize
    
    var body: some View {
        RoundedRectangle(cornerRadius: size.height * 0.5)
            .fill(Color.white)
            .frame(width: size.width * 0.6, height: size.height * 0.08)
    }
    
}

struct BurgerButton_Previews: PreviewProvider {
    static var previews: some View {
        BurgerButton {
            print("Tapped")
        }
    }
}
