//
//  SegmentView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 22/07/2020.
//

import SwiftUI

struct SegmentView: View {
    
    private struct Constants {
        
        static let errorImageName = "cactus"
        static let errorText = "Looks like there's nothing here! Maybe try loading again."
        static let retryButtonTitle = "Reload"
        
    }
    
    @ObservedObject var viewModel: SegmentViewModel
    
    var body: some View {
        VStack {
            if !viewModel.error && viewModel.itemIds.isEmpty {
                ProgressView()
            } else if viewModel.error {
                Image(Constants.errorImageName)
            Text(Constants.errorText)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color(red: 126/255, green: 126/255, blue: 126/255))
                Button(Constants.retryButtonTitle) {
                    viewModel.retry()
                }
                .foregroundColor(.white)
                .font(.title2)
                .padding()
                .padding(.horizontal, 40)
                .background(Capsule().foregroundColor(.blue))
            } else {
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
    }
    
}

struct SegmentView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentView(viewModel: SegmentViewModel(segment: .top))
    }
}
