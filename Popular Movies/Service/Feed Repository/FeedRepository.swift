//
//  FeedRepository.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

protocol FeedRepositoryProtocol {
    func fetchMovies(page: Int, completion: @escaping(Result<[MovieCellItem], CustomError>) -> Void)
}

final class FeedRepository {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        self.service = service
    }
    
}

extension FeedRepository: FeedRepositoryProtocol {
    func fetchMovies(page: Int, completion: @escaping(Result<[MovieCellItem], CustomError>) -> Void) {
        guard let url = EndPoint.popularMovies(page: page).endPoint else {
            completion(.failure(CustomError(message: "Corrupted URL")))
            return
        }
        service.request(url: url) { (result: Result<MovieNetworkList, CustomError>) in
            print(result)
            switch result {
            case .success(let success):
                let movieList = success.results.map(MovieCellItem.init)
                // TODO: Persistence
                completion(.success(movieList))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}

//                PostPersistentAdapter.shared.generateDatabasePostObjects(from: posts)

//                let list = PostPersistentAdapter.shared.pullDatabasePostObjects()
//                let posts: [PostCellModel] = list.map { PostCellModel(from: $0) }
//                if list.isEmpty {
//                    completion(.failure(failure))
//                } else {
//                    completion(.success(posts))
//                }
