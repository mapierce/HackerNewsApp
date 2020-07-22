//
//  ContainerView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

struct ContainerView: View {
    
    let text: String
    
    var body: some View {
        Text(text)
    }
    
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView(text: "Title")
    }
}
