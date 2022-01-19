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
    var imageURL: String?
    var genres: [Int]
    var rating: Double
    var releaseDate: String
    
    init(with networkData: MovieNetworkItem) {
        self.id = networkData.id
        self.title = networkData.title
        self.imageURL = networkData.imagePath
        self.genres = networkData.genres
        self.rating = networkData.rating
        self.releaseDate = networkData.releaseDate
    }
}

extension MovieCellItem {
    var genreArrayString: [String] {
        genres.map {
            GenreManager.shared.getNameForGenre($0) ?? "Undefined"
        }
    }
    
    var dateOfReleaseString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: releaseDate) ?? Date()
        let calendar = Calendar.current
        return String(format: "%d", calendar.component(.year, from: date))
    }
}
