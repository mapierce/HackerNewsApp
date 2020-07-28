//
//  SegmentView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

struct SegmentView: View {
    
    @ObservedObject var viewModel: SegmentViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.itemIds, id: \.self) { id in
                    ItemView(viewModel: ItemViewModel(itemId: id))
                        .cornerRadius(15)
                        .padding()
                        .shadow(radius: 3)
                }
            }
        }
    }
    
}

struct SegmentView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentView(viewModel: SegmentViewModel(segment: .top))
    }
}
