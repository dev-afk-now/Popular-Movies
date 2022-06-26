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
    var tagline: String?
    var posterPath: String?
    var rating: Double
    var releaseDate: String
    
    init(with networkDetail: NetworkDetailData) {
        self.id = networkDetail.id
        self.title = networkDetail.title
        self.productionCountries = networkDetail.productionCountries
        self.genres = networkDetail.genres.map(MovieGenre.init)
        self.overview = networkDetail.overview ?? ""
        self.tagline = networkDetail.tagline
        self.posterPath = networkDetail.imagePath
        self.rating = networkDetail.rating
        self.releaseDate = networkDetail.releaseDate
    }
}

extension DetailModel {
    var yearOfReleaseString: String {
        return Date.calendarComponentString(stringDate: releaseDate,
                                            dateFormat: "yyyy-MM-dd",
                                            component: .year)
    }
}

extension Date {
    static func calendarComponentString(stringDate: String,
                                    dateFormat: String,
                                    component: Calendar.Component) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: stringDate) ?? Date()
        let calendar = Calendar.current
        return String(format: "%d", calendar.component(component, from: date))
    }
}
