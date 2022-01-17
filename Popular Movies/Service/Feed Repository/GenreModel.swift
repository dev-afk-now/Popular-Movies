//
//  GenreModel.swift
//  Popular Movies
//
//  Created by devmac on 17.01.2022.
//

import Foundation

struct NetworkGenreData: Codable {
    var genres: [MovieGenre]
}

struct MovieGenre: Codable {
    var id: Int
    var name: String
}
