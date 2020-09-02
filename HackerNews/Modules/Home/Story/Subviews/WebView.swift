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
    
    @Binding var progress: Double
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
        return Coordinator($progress)
    }
    
    class Coordinator: NSObject {
        
        var progress: Binding<Double>
        
        init(_ progress: Binding<Double>) {
            self.progress = progress
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            guard keyPath == #keyPath(WKWebView.estimatedProgress), let webView = object as? WKWebView else { return }
            progress.wrappedValue = webView.estimatedProgress
        }
        
    }
    
}
