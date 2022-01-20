//
//  NetworkDetailData.swift
//  Popular Movies
//
//  Created by Никита Дубовик on 18.01.2022.
//

import Foundation

struct NetworkDetailData: Codable {
    var id: Int
    var title: String
    var overview: String?
    var genres: [NetworkGenreData]
    var productionCountries: [CountryModel]
    var posterPath: String?
    var rating: Double
    var releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case genres
        case productionCountries = "production_countries"
        case posterPath = "poster_path"
        case rating = "vote_average"
        case releaseDate = "release_date"
    }
}

extension NetworkDetailData {
    var imagePath: String? {
        guard let path = posterPath else {
            return nil
        }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
}
