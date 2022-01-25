//
//  MoviePersistentAdapter.swift
//  Popular Movies
//
//  Created by devmac on 20.01.2022.
//

import Foundation

final class MoviePersistentAdapter {
    static let shared = MoviePersistentAdapter()
    
    private init() {}
    
    func generateDatabasePostObjects(from movieList: [MovieCellItem]) {
        let savedObjects = pullDatabasePostObjects()
        for movie in movieList {
            guard (savedObjects.first { $0.id == movie.id }) == nil else {
                continue
            }
            generateDatabaseMovieObject(from: movie)
        }
    }
    
    func generateDatabaseMovieObject(from movieModel: MovieCellItem) {
        let object = MoviePersistentData(context: PersistentService.shared.context)
        print("created: \(movieModel.id)")
        object.id = movieModel.id.int64value
        object.releaseDate = movieModel.releaseDate
        object.rating = movieModel.rating
        object.genres = movieModel.genres
        object.imageURL = movieModel.imageURL
        object.title = movieModel.title
        PersistentService.shared.save()
    }
    
    func pullDatabasePostObjects() -> [MoviePersistentData] {
        return PersistentService.shared.fetchObjects(entity: MoviePersistentData.self)
    }
}

extension Int {
    var int64value: Int64 {
        Int64(self)
    }
}
