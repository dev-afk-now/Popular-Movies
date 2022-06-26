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
                      completion: @escaping (Result<MovieListContainer, CustomError>) -> ())
    func searchMovies(keyword: String,
                      page: Int,
                      completion: @escaping (Result<MovieListContainer, CustomError>) -> ())
    func fetchDataBaseObjects(completion: @escaping (MovieListContainer) -> ())
}

final class FeedRepository {}

extension FeedRepository: FeedRepositoryProtocol {
    func fetchDataBaseObjects(completion: @escaping (MovieListContainer) -> ()) {
        completion(MovieListContainer(objects: MoviePersistentAdapter.shared
                                        .pullDatabaseMovieObjects()
                                        .map(MovieCellItem.init))
        )
    }
    
    func fetchMovieGenres(completion: EmptyBlock? = nil) {
        GenreManager.shared.fetchGenreData(completion: completion)
    }
    
    func fetchPopular(page: Int,
                      sortBy: String,
                      completion: @escaping (Result<MovieListContainer, CustomError>) -> ()) {
        let endPoint: EndPoint = .popular(page: page, sortBy: sortBy)
        NetworkService.shared.request(endPoint: endPoint) {
            (result: Result<MovieNetworkListResponse, CustomError>) in
            switch result {
            case .success(let networkContainer):
                let movies = networkContainer.results.map(MovieCellItem.init)
                MoviePersistentAdapter.shared.generateDatabaseMovieObjects(from: movies)
                completion(.success(MovieListContainer(with: networkContainer)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchMovies(keyword: String,
                      page: Int,
                      completion: @escaping (Result<MovieListContainer, CustomError>) -> ()) {
        let endPoint: EndPoint = .searchMovies(query: keyword.trimmingCharacters(in: .whitespacesAndNewlines),
                                               page: page)
        NetworkService.shared.request(endPoint: endPoint) {
            (result: Result<MovieNetworkListResponse, CustomError>) in
            switch result {
            case .success(let networkContainer):
                let movies = networkContainer.results.map(MovieCellItem.init)
                MoviePersistentAdapter.shared.generateDatabaseMovieObjects(from: movies)
                completion(.success(MovieListContainer(with: networkContainer)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
