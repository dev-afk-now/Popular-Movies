//
//  NetworkDetailData.swift
//  Popular Movies
//
//  Created by Никита Дубовик on 18.01.2022.
//

import Foundation

struct NetworkDetailData: Decodable {
    var id: Int
    var title: String
    var genres: [NetworkGenreData]
    var backdropPath: String?
    var rating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case genres
        case backdropPath = "backdrop_path"
        case rating = "vote_average"
    }
}
