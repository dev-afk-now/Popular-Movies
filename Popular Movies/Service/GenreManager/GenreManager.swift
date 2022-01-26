//
//  GenreManager.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import Foundation

final class GenreManager {
    static let shared = GenreManager()
    
    private var genres = [MovieGenre]()
    
    private init() {}
    
    func fetchGenreData(completion: EmptyBlock? = nil) {
        DispatchQueue.global(qos: .background).async {
            NetworkService.shared.request(endPoint: .genres) {
                (result: Result<NetworkGenreList, CustomError>) in
                switch result {
                case .success(let genreData):
                    print(genreData)
                    self.genres = genreData.genres.map(MovieGenre.init)
                    GenrePersistentAdapter
                        .shared
                        .generateDatabaseGenreObjects(from: self.genres)
                    completion?()
                case .failure:
                    self.genres = GenrePersistentAdapter
                        .shared
                        .pullDatabaseGenreObjects()
                        .map { MovieGenre.init(from: $0) }
                }
            }
        }
    }
    
    func getNameForGenre(_ genreId: Int) -> String? {
        return genres.first { genreId == $0.id }?.name
    }
}
