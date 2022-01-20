//
//  MovieGenre.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import Foundation

struct MovieGenre: Codable {
    var id: Int
    var name: String
    
    init(networkItem: NetworkGenreData) {
        id = networkItem.id
        name = networkItem.name
    }
    
    init(from model: GenrePersistentData) {
        self.id = Int(model.id)
        self.name = model.name ?? ""
    }
}
