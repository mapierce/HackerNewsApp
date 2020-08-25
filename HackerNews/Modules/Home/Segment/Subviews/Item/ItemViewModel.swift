//
//  ItemViewModel.swift
//  HackerNews
//
//  Created by Matthew Pierce on 24/07/2020.
//

import Foundation
import Combine
import SwiftUI

class ItemViewModel: ObservableObject {
    
    private struct Constants {
        
        static let fallbackStoryTitle = "HackerNews: Story"
        static let fallbackJobTitle = "HackerNews: Job"
        static let fallbackPollTitle = "HackerNews: Poll"
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
    
    @Published private(set) var title = "Placeholder text going in here just for the redaction"
    @Published private(set) var metadata = "Placeholder text going in here just for the redaction"
    @Published private(set) var image: Image?
    @Published private(set) var viewState: ViewState = .loading
    @Published private(set) var tags = [TagTypes]()
    private let itemId: Int
    private let itemRepository: ItemRespository
    private let imageRepository: ImageRepository
    private var cancellables: Set<AnyCancellable> = []
    private var fetchCount = 0 // remove this and everything related to it
    
    private var viewStateInternal: ViewState = .loading {
        willSet {
            withAnimation {
                viewState = newValue
            }
        }
    }
    
    // MARK: - Initialization
    
    init(
        itemRepository: ItemRespository = ItemRespository(),
        imageRepository: ImageRepository = ImageRepository(),
        itemId: Int
    ) {
        self.itemRepository = itemRepository
        self.imageRepository = imageRepository
        self.itemId = itemId
        handleItemRepository()
        handleImageRepository()
    }
    
    // MARK: - Public methods
    
    func fetch() {
        viewStateInternal = .loading
        fetch(itemId)
        tags = []
    }
    
    func cancel() {
        itemRepository.cancel()
        imageRepository.cancel()
    }
    
    // MARK: - Private methods
    
    private func fetch(_ itemId: Int) {
        itemRepository.fetch(by: itemId, forceRefresh: false)
    }
    
    private func handleItemRepository() {
        itemRepository.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure: self?.viewStateInternal = .error
                case .finished: break
                }
            } receiveValue: { [weak self] item in
                self?.handle(item: item)
            }
            .store(in: &cancellables)
    }
    
    private func handleImageRepository() {
        imageRepository.publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure: return // Won't happen, as repository will return stock image
                case .finished: break
                }
            } receiveValue: { [weak self] image in
                withAnimation {
                    self?.image = image
                }
            }.store(in: &cancellables)
    }
    
    private func handle(item: Item?) {
        guard let item = item else {
            viewStateInternal = .error
            return
        }
        viewStateInternal = .complete
        var score: Int? = nil
        var url: String? = nil
        let by: String? = item.by
        let time: Int? = item.time
        switch item {
        case .story(let storyItem):
            score = storyItem.score
            url = storyItem.url
            title = storyItem.title ?? Constants.fallbackStoryTitle
        case .job(let jobItem):
            url = jobItem.url
            title = jobItem.title ?? Constants.fallbackJobTitle
            tags.append(.job)
        case .poll(let pollItem):
            score = pollItem.score
            title = pollItem.title ?? Constants.fallbackPollTitle
            tags.append(.poll)
        default: return
        }
        if item.dead ?? false {
            tags.append(.dead)
        }
        buildMetadata(from: score, by: by, time: time)
        loadImage(for: item.uuid, with: url)
    }
    
    private func loadImage(for id: Int, with url: String?) {
        let imageUrl: URL? = URL(string: url ?? "")
        imageRepository.fetch(by: (id, imageUrl), forceRefresh: false)
    }
    
    // MARK: - Formatters
    
    private func buildMetadata(from score: Int?, by: String?, time: Int?) {
        var metadataString = ""
        if let score = score {
            metadataString.append("\(score) \(Constants.points) ")
        }
        if let by = by {
            let author = "\(Constants.by) \(by)"
            metadataString.isEmpty ? metadataString = "\(author.capitalizingFirstLetter()) " : metadataString.append("\(author) ")
        }
        if let time = time {
            metadataString.append("\(getPrettyTime(from: time))")
        }
        metadata = metadataString
    }
    
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
