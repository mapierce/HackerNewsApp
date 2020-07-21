//
//  AllView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import SwiftUI

struct AllView: View {
    var body: some View {
        List {
            Text("One")
            Text("Two")
            Text("Three")
        }
    }
}

struct AllView_Previews: PreviewProvider {
    static var previews: some View {
        AllView()
    }
}
