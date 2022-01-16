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
    private let service: NetworkServiceProtocol
    private let imageService: ImageService
    
    init(networkService: NetworkServiceProtocol,
         imageService: ImageService) {
        self.service = networkService
        self.imageService = imageService
    }
    
    private func createMovieItems(movieList: @escaping([MovieNetworkItem]) -> ()) {
        let movieList = success.results.map {
            [weak self] movie -> MovieCellItem in
            var newMovie = MovieCellItem(with: movie)
               self?.imageService.fetchImage(movie.imageURL) { local in
                   newMovie.imageURL = local
               }
            return newMovie
        }
    }
}

extension FeedRepository: FeedRepositoryProtocol {
    func fetchPopular(page: Int,
                      completion: @escaping (Result<[MovieCellItem], CustomError>) -> ()) {
        let endPoint: EndPoint = .popular(page: page)
        requestForMovies(endPoint: endPoint) { result in
            switch result {
            case .success(let success):

                // TODO: Persistence
                completion(.success(movieList))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func searchMovies(keyword: String,
                      page: Int,
                      completion: @escaping (Result<[MovieCellItem], CustomError>) -> ()) {
        let endPoint: EndPoint = .searchMovies(query: keyword, page: page)
        requestForMovies(endPoint: endPoint) { result in
            switch result {
            case .success(let success):
                self.createImages(contentsOf: success.results.map{ $0.imageURL })
                let movieList = success.results.map(MovieCellItem.init)
                // TODO: Persistence
                completion(.success(movieList))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func requestForMovies(endPoint: EndPoint,
                          completion: @escaping(Result<MovieNetworkList, CustomError>) -> ()) {
        service.request(endPoint: endPoint) { result in
            completion(result)
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
