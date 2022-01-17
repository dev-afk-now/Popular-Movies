//
//  MovieNetworkItem.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

struct MovieNetworkList: Codable {
    var results: [MovieNetworkItem]
}

struct MovieNetworkItem: Codable {
    var id: Int
    var title: String
    var genres: [Int]
    var backdropPath: String?
    var rating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case genres = "genre_ids"
        case backdropPath = "backdrop_path"
        case rating = "vote_average"
    }
}

extension MovieNetworkItem {
    var imageURL: String? {
        guard let path = backdropPath else {
            return nil
        }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
}
