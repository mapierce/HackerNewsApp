//
//  Item+Metadata.swift
//  HackerNews
//
//  Created by Matthew Pierce on 07/10/2020.
//

import Foundation

private struct Constants {
    
    static let points = "points"
    static let by = "by"
    static let ago = "ago"
    static let minute = "minute"
    static let minutes = "minutes"
    static let hour = "hour"
    static let hours = "hours"
    static let day = "day"
    static let days = "days"
    static let week = "week"
    static let weeks = "weeks"
    
}

extension Item {
    
    var shareURL: String {
        return self.url ?? "https://news.ycombinator.com/item?id=\(self.uuid)"
    }
    
    func buildMetadata() -> String {
        var metadata = ""
        if let score = self.score {
            metadata.append("\(score) \(Constants.points) ")
        }
        if let by = self.by {
            let author = "\(Constants.by) \(by)"
            metadata.isEmpty ? metadata = "\(author.capitalizingFirstLetter()) " : metadata.append("\(author) ")
        }
        if let time = self.time {
            metadata.append("\(getPrettyTime(from: time))")
        }
        return metadata
    }
    
    // MARK: - Utility methods
    
    private func getPrettyTime(from time: Int) -> String {
        let calendar: Calendar = .current
        let timestamp = Date(timeIntervalSince1970: TimeInterval(time))
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear], from: timestamp, to: Date())
        var prettyTime = ""
        if let week = components.weekOfYear, week > 0 {
            prettyTime = "\(week) \(week > 1 ? Constants.weeks : Constants.week) \(Constants.ago)"
        } else if let day = components.day, 1..<7 ~= day {
            prettyTime = "\(day) \(day > 1 ? Constants.days : Constants.day) \(Constants.ago)"
        } else if let hour = components.hour, 1..<24 ~= hour {
            prettyTime = "\(hour) \(hour > 1 ? Constants.hours : Constants.hour) \(Constants.ago)"
        } else if let minute = components.minute, 1..<60 ~= minute {
            prettyTime = "\(minute) \(minute > 1 ? Constants.minutes : Constants.minute) \(Constants.ago)"
        }
        return prettyTime
    }
    
}
