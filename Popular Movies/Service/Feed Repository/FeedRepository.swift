//
//  FeedRepository.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

protocol FeedRepositoryProtocol {
    func fetchMovieGenres(completion: EmptyBlock?)
    func fetchPopular(page: Int,
                      sortBy: String,
                      completion: @escaping (Result<[MovieCellItem], CustomError>) -> ())
    func searchMovies(keyword: String,
                      page: Int,
                      completion: @escaping(Result<[MovieCellItem], CustomError>) -> ())
}

final class FeedRepository {}

extension FeedRepository: FeedRepositoryProtocol {
    func fetchMovieGenres(completion: EmptyBlock? = nil) {
        GenreManager.shared.fetchGenreData(completion: completion)
    }
    
    func fetchPopular(page: Int,
                      sortBy: String,
                      completion: @escaping (Result<[MovieCellItem], CustomError>) -> ()) {
        let endPoint: EndPoint = .popular(page: page, sortBy: sortBy)
        NetworkService.shared.request(endPoint: endPoint) {
            (result: Result<MovieNetworkList, CustomError>) in
            switch result {
            case .success(let success):
                let movies = success.results.map(MovieCellItem.init)
                // TODO: Persistence
                completion(.success(movies))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func searchMovies(keyword: String,
                      page: Int,
                      completion: @escaping (Result<[MovieCellItem], CustomError>) -> ()) {
        let endPoint: EndPoint = .searchMovies(query: keyword, page: page)
        NetworkService.shared.request(endPoint: endPoint) {
            (result: Result<MovieNetworkList, CustomError>) in
            switch result {
            case .success(let success):
                let movies = success.results.map(MovieCellItem.init)
                // TODO: Persistence
                completion(.success(movies))
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
