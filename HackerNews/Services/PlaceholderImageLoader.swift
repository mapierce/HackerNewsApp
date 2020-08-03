//
//  PlaceholderImageLoader.swift
//  HackerNews
//
//  Created by Matthew Pierce on 03/08/2020.
//

import SwiftUI

class PlaceholderImageLoader {
    
    static let shared = PlaceholderImageLoader()
    private let placeholderImages = ["orangeItemPlaceholder", "blueItemPlaceholder", "greenItemPlaceholder"]
    private var currentPlacholderIndex = 0
    
    private init() {}
    
    // MARK: - Public methods
    
    func getNextPlaceholderImage() -> Image {
        if currentPlacholderIndex == placeholderImages.count - 1 {
            currentPlacholderIndex = 0
        }
        let placeholderImage = Image(placeholderImages[currentPlacholderIndex])
        currentPlacholderIndex += 1
        return placeholderImage
    }
    
}
