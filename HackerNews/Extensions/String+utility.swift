//
//  String+utility.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import Foundation

extension String {
    
    func format(_ arguments: CVarArg...) -> String {
        let args = arguments.map {
            if let arg = $0 as? Int { return String(arg) }
            if let arg = $0 as? Float { return String(arg) }
            if let arg = $0 as? Double { return String(arg) }
            if let arg = $0 as? Int64 { return String(arg) }
            if let arg = $0 as? String { return String(arg) }
            return "(null)"
        } as [CVarArg]
        return String(format: self, arguments: args)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}
