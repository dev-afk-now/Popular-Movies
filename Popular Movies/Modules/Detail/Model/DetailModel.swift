//
//  DetailModel.swift
//  Popular Movies
//
//  Created by devmac on 19.01.2022.
//

import Foundation

struct DetailModel: Decodable {
    var id: Int
    var title: String
    var genres: [MovieGenre]
    var productionCountries: [CountryModel]
    var overview: String
    var posterPath: String?
    var rating: Double
    var releaseDate: String
    
    init(with networkDetail: NetworkDetailData) {
        self.id = networkDetail.id
        self.title = networkDetail.title
        self.productionCountries = networkDetail.productionCountries
        self.genres = networkDetail.genres.map(MovieGenre.init)
        self.overview = networkDetail.overview ?? ""
        self.posterPath = networkDetail.imagePath
        self.rating = networkDetail.rating
        self.releaseDate = networkDetail.releaseDate
    }
    
    var dateOfReleaseString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: releaseDate) ?? Date()
        let calendar = Calendar.current
        return String(format: "%d", calendar.component(.year, from: date))
    }
}
