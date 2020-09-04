//
//  WebViewStateModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 02/09/2020.
//

import Foundation

class WebViewStateModel: ObservableObject {
    
    @Published var progress = 0.0
    @Published var canGoBack = false
    @Published var canGoForwards = false
    @Published var goBack = false
    @Published var goForwards = false
    @Published var reload = false
    
}
