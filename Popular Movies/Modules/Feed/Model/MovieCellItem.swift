//
//  MovieItem.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

struct MovieListContainer {
    var totalMovies: Int
    var movies: [MovieCellItem]
    
    init(with networkData: MovieNetworkListResponse) {
        self.totalMovies = networkData.totalResults
        self.movies = networkData.results.map(MovieCellItem.init)
    }
    
    init(objects: [MovieCellItem]) {
        self.totalMovies = objects.count
        self.movies = objects
    }
}

struct MovieCellItem {
    var id: Int
    var title: String
    var imageURL: String?
    var genres: [Int]
    var rating: Double
    var releaseDate: String
    
    init(with networkData: MovieNetworkItem) {
        self.id = networkData.id
        self.title = networkData.originalTitle
        self.imageURL = networkData.imagePath
        self.genres = networkData.genres
        self.rating = networkData.rating
        self.releaseDate = networkData.releaseDate ?? ""
    }
    
    init(from model: MoviePersistentData) {
        self.id = Int(model.id)
        self.title = model.title ?? ""
        self.imageURL = model.imageURL ?? ""
        self.rating = model.rating
        self.releaseDate = model.releaseDate ?? ""
        self.genres = model.genres ?? []
    }
}

extension MovieCellItem {
    var genreArrayString: [String] {
        genres.map {
            GenreManager.shared.getNameForGenre($0) ?? "Undefined"
        }
    }
    
    var dateOfReleaseString: String {
        return Date.calendarComponentString(stringDate: releaseDate,
                                            dateFormat: "yyyy-MM-dd",
                                            component: .year)
    }
}
