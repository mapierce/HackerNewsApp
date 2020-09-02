//
//  WebView.swift
//  HackerNews
//
//  Created by Matthew Pierce on 26/08/2020.
//

import UIKit
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    
    @ObservedObject var stateModel: WebViewStateModel
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        uiView.removeObserver(coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(stateModel: stateModel)
    }
    
    class Coordinator: NSObject {
        
        @ObservedObject var stateModel: WebViewStateModel
        
        init(stateModel: WebViewStateModel) {
            self.stateModel = stateModel
        }
        
        override func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey : Any]?,
            context: UnsafeMutableRawPointer?
        ) {
            guard keyPath == #keyPath(WKWebView.estimatedProgress), let webView = object as? WKWebView else { return }
            stateModel.progress = webView.estimatedProgress
        }
        
    }
    
}
