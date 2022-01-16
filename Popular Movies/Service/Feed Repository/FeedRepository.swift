//
//  FeedRepository.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

protocol FeedRepositoryProtocol {
    func fetchPopular(page: Int,
                      completion: @escaping(Result<[MovieCellItem], CustomError>) -> ())
    func searchMovies(keyword: String,
                      page: Int,
                      completion: @escaping(Result<[MovieCellItem], CustomError>) -> ())
}

final class FeedRepository {
    private let networkService: NetworkServiceProtocol
    private let imageService: ImageService
    
    init(networkService: NetworkServiceProtocol,
         imageService: ImageService) {
        self.networkService = networkService
        self.imageService = imageService
    }
    
    private func createMovieItems(movieList: [MovieNetworkItem],
                                  completion: @escaping([MovieCellItem]) -> ()) {
        let movies = movieList.map { [weak self] movie -> MovieCellItem in
            var newMovie = MovieCellItem(with: movie)
               self?.imageService.fetchImage(movie.imageURL) { local in
                   newMovie.imageURL = local
               }
            return newMovie
        }
        completion(movies)
    }
}

extension FeedRepository: FeedRepositoryProtocol {
    func fetchPopular(page: Int,
                      completion: @escaping (Result<[MovieCellItem], CustomError>) -> ()) {
        let endPoint: EndPoint = .popular(page: page)
        networkService.request(endPoint: endPoint) {
            (result: Result<MovieNetworkList, CustomError>) in
            switch result {
            case .success(let success):
                self.createMovieItems(movieList: success.results) { movies in
                    completion(.success(movies))
                }
                // TODO: Persistence
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func searchMovies(keyword: String,
                      page: Int,
                      completion: @escaping (Result<[MovieCellItem], CustomError>) -> ()) {
        let endPoint: EndPoint = .searchMovies(query: keyword, page: page)
        networkService.request(endPoint: endPoint) {
            (result: Result<MovieNetworkList, CustomError>) in
            switch result {
            case .success(let success):
                self.createMovieItems(movieList: success.results) { movies in
                    completion(.success(movies))
                }
                // TODO: Persistence
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
