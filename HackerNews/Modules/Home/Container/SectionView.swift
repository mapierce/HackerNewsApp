//
//  SectionView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

struct SectionView: View {
    
    @ObservedObject var viewModel: SectionViewModel
    
    var body: some View {
        List(viewModel.itemIds, id: \.self) { id in
            VStack {
                Text("\(id)")
            }
        }
    }
    
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(viewModel: SectionViewModel(segment: .top))
    }
}
