//
//  GenreModel.swift
//  Popular Movies
//
//  Created by devmac on 17.01.2022.
//

import Foundation

struct NetworkGenreList: Codable {
    var genres: [NetworkGenreData]
}

struct NetworkGenreData: Codable {
    var id: Int
    var name: String
}
