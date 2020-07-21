//
//  Path.swift
//  HackerNews
//
//  Created by Matthew Pierce on 21/07/2020.
//

import Foundation

enum Path: String {
    case maxItem = "/maxitem.json"
    case topStories = "/topstories.json"
    case ask = "/askstories.json"
    case show = "/showstories.json"
    case jobs = "/jobstories.json"
    case item = "/item/%@.json"
}
