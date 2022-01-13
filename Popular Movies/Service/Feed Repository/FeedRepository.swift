//
//  FeedRepository.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

protocol FeedRepositoryProtocol {
    func fetchMovies(keyword: String?,
                     page: Int,
                     completion: @escaping(Result<[MovieCellItem], CustomError>) -> ())
}

final class FeedRepository {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        self.service = service
    }
}

extension FeedRepository: FeedRepositoryProtocol {
    func fetchMovies(keyword: String?,
                     page: Int,
                     completion: @escaping(Result<[MovieCellItem], CustomError>) -> ()) {
        var endPoint: EndPoint {
            if let keyword = keyword {
                return EndPoint.searchMovies(query: keyword, page: page)
            } else {
                return EndPoint.popular(page: page)
            }
        }
        service.request(endPoint: endPoint) { (result: Result<MovieNetworkList, CustomError>) in
            print(endPoint.fullURLString())
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
