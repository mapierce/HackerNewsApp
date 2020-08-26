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
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.load(request)
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
}
