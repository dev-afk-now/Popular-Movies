//
//  GenreModel.swift
//  Popular Movies
//
//  Created by devmac on 17.01.2022.
//

import Foundation

struct NetworkGenreData: Decodable {
    var genres: [MovieGenre]
}

struct MovieGenre: Decodable {
    var id: Int
    var name: String
}
