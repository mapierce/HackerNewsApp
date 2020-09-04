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
    
    private struct Constants {
        
        static let estimatedProgress = #keyPath(WKWebView.estimatedProgress)
        static let canGoForward = #keyPath(WKWebView.canGoForward)
        static let canGoBack = #keyPath(WKWebView.canGoBack)
        
    }
    
    @ObservedObject var stateModel: WebViewStateModel
    let request: URLRequest
    
    // MARK: - UIViewRepresentable methods
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        addObservers(for: webView, with: context)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.canGoBack && stateModel.goBack {
            uiView.goBack()
            stateModel.goBack = false
        }
        if uiView.canGoForward && stateModel.goForwards {
            uiView.goForward()
            stateModel.goForwards = false
        }
        if stateModel.reload {
            uiView.reload()
            stateModel.reload = false
        }
    }
    
    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        uiView.removeObserver(coordinator, forKeyPath: Constants.estimatedProgress)
        uiView.removeObserver(coordinator, forKeyPath: Constants.canGoForward)
        uiView.removeObserver(coordinator, forKeyPath: Constants.canGoBack)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(stateModel: stateModel)
    }
    
    // MARK: - Private methods
    
    private func addObservers(for webView: WKWebView, with context: Context) {
        webView.addObserver(context.coordinator, forKeyPath: Constants.estimatedProgress, options: .new, context: nil)
        webView.addObserver(context.coordinator, forKeyPath: Constants.canGoForward, options: .new, context: nil)
        webView.addObserver(context.coordinator, forKeyPath: Constants.canGoBack, options: .new, context: nil)
    }
    
    // MARK: - Coordinator
    
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
            guard let webView = object as? WKWebView else { return }
            if keyPath == Constants.estimatedProgress {
                stateModel.progress = webView.estimatedProgress
            } else if keyPath == Constants.canGoBack {
                stateModel.canGoBack = webView.canGoBack
            } else if keyPath == Constants.canGoForward {
                stateModel.canGoForwards = webView.canGoForward
            }
        }
        
    }
    
}

extension WebView.Coordinator: WKNavigationDelegate {
    
}
