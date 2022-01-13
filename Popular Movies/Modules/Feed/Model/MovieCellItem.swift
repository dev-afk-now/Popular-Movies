//
//  MovieItem.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

struct MovieCellItem {
    var id: Int
    var title: String
    var backdropPath: String?
    var genres: [Int]
    var rating: Double
    
    init(with networkData: MovieNetworkItem) {
        self.id = networkData.id
        self.title = networkData.title
        self.backdropPath = networkData.backdropPath
        self.genres = networkData.genres
        self.rating = networkData.rating
    }
}
