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
    
    func generateDatabaseGenreObjects(from postList: [MovieGenre]) {
        postList.forEach{ generateDatabaseGenreObject(from: $0) }
    }
    
    func generateDatabaseGenreObject(from movieModel: MovieGenre) {
        let object = GenrePersistentData(context: PersistentService.shared.context)
        object.id = movieModel.id.int64value
        object.name = movieModel.name
        PersistentService.shared.save()
    }
    
    func pullDatabasePostObjects() -> [GenrePersistentData] {
        return PersistentService.shared.fetchObjects(entity: GenrePersistentData.self)
    }
}
