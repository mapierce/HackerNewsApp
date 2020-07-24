//
//  URLRequest+Init.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import Foundation

extension URLRequest {
    
    init(path: Path, method: HTTPRequestMethod = .get) {
        self = URLRequest(path: path.rawValue, method: method)
    }
    
    init(path: String, method: HTTPRequestMethod = .get) {
        assert(URL(string: URLRequest.baseURL + path) != nil)
        var request = URLRequest(url: URL(string: URLRequest.baseURL + path)!)
        request.httpMethod = method.rawValue
        self = request
    }
    
    private static var baseURL: String {
        return "https://hacker-news.firebaseio.com/v0"
    }
    
}
