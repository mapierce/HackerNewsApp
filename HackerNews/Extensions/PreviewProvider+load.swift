//
//  PreviewProvider+load.swift
//  HackerNews
//
//  Created by Matthew Pierce on 27/07/2020.
//

import SwiftUI

extension PreviewProvider {
    
    static func load<T: Decodable>(_ filename: String) -> T {
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else { fatalError("Couln't load file") }
        let data: Data
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load contents of file")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse file:\n\(error)")
        }
    }
    
}
