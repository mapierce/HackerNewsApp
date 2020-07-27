//
//  ItemView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import SwiftUI

struct ItemView: View {
    
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        if let item = viewModel.item {
            Text("\(item.by ?? "No author")")
        } else {
            ProgressView()
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(viewModel: ItemViewModel(itemId: 23940626))
    }
}
