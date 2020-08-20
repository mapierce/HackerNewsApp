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
        VStack {
            switch viewModel.viewState {
            case .loading: ProgressView()
            case .error: ErrorView { viewModel.retry() }
            case .complete: ItemListView(itemIds: viewModel.itemIds)
            }
        }
    }
    
}

struct SegmentView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentView(viewModel: SegmentViewModel(segment: .top))
    }
}
