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
        List(viewModel.itemIds, id: \.self) { id in
            VStack {
                Text("\(id)")
            }
        }
    }
    
}

struct SegmentView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentView(viewModel: SegmentViewModel(segment: .top))
    }
}
