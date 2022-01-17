//
//  SortOption.swift
//  Popular Movies
//
//  Created by devmac on 17.01.2022.
//

import Foundation

enum SortOption: String, CaseIterable {
    case mostPopular = "popularity.desc"
    case highestRating = "vote_average.desc"
    case mostVoted = "vote_count.desc"
    case newest = "release_date.desc"
    case title = "original_title.desc"
    
    var message: String {
        switch self {
        case .mostPopular:
            return "Sort by most popular"
        case .highestRating:
            return "Sort by highest rating"
        case .mostVoted:
            return "Sort by most voted"
        case .newest:
            return "Sort by newest"
        case .title:
            return "Title by A-Z"
        }
    }
}
