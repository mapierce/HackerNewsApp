//
//  ItemImageView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 20/08/2020.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct ItemImageView: View {
    
    private struct Constants {
        
        static let imageFrameHeight: CGFloat = 155
        static let tagSpacing: CGFloat = 3
        static let tagPadding: CGFloat = 2
        static let tagWidth: CGFloat = 55
        static let tagStrokeWidth: CGFloat = 3
        
    }
    
    var imageType: ImageType?
    var tags: [TagTypes]
    
    var body: some View {
        ZStack {
            if let loadedImageType = imageType {
                switch loadedImageType {
                case .local(let imageName):
                    Image(imageName)
                        .resizable()
                        .frame(height: Constants.imageFrameHeight)
                case .remote(let url):
                    KFImage(
                        url,
                        options: [
                            .processor(DownsamplingImageProcessor(size: CGSize(width: UIScreen.main.bounds.width, height: Constants.imageFrameHeight))),
                            .scaleFactor(UIScreen.main.scale)
                        ]
                    )
                    .cancelOnDisappear(true)
                    .placeholder {
                        ItemPlaceholderImage()
                    }
                    .resizable()
                    .frame(height: Constants.imageFrameHeight)
                }
            } else {
                ItemPlaceholderImage()
            }
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    VStack(spacing: Constants.tagSpacing) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag.rawValue.uppercased())
                                .bold()
                                .foregroundColor(tag.associatedColor)
                                .font(.footnote)
                                .clipShape(Rectangle())
                                .padding(.vertical, Constants.tagPadding)
                                .frame(width: Constants.tagWidth)
                                .border(tag.associatedColor, width: Constants.tagStrokeWidth)
                                .background(Color.primary.colorInvert())
                                .cornerRadius(3)
                        }
                    }
                    Spacer().frame(height: 4)
                }
                Spacer().frame(width: 4)
            }
        }
    }
    
}

struct ItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        ItemImageView(imageType: nil, tags: [.poll, .job, .dead])
            .previewLayout(.fixed(width: 300, height: 155))
            .environment(\.colorScheme, .dark)
    }
}
