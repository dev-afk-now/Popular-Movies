//
//  GenrePersistentAdapter.swift
//  Popular Movies
//
//  Created by devmac on 20.01.2022.
//

import Foundation

final class GenrePersistentAdapter {
    static let shared = GenrePersistentAdapter()
    
    private init() {}
    
    func generateDatabaseGenreObjects(from genreList: [MovieGenre]) {
        genreList.forEach{ generateDatabaseGenreObject(from: $0) }
    }
    
    func generateDatabaseGenreObject(from genreModel: MovieGenre) {
        let object = GenrePersistentData(context: PersistentService.shared.context)
        object.id = genreModel.id.int64value
        object.name = genreModel.name
        PersistentService.shared.save()
    }
    
    func pullDatabaseGenreObjects() -> [GenrePersistentData] {
        return PersistentService.shared.fetchObjects(entity: GenrePersistentData.self)
    }
}
