//
//  FeedRepository.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

protocol FeedRepositoryProtocol {
    func getPosts(completion: @escaping() -> Void)
}

final class FeedRepository {
    enum Error: Swift.Error {
        case propagated(Swift.Error)
        case offlined
        case timeOut
    }
    
    private let service: NetworkService
    
    private let listPath = URL(
        string: "https://api.themoviedb.org/3/movie/popular?api_key=748bef7b95d85a33f87a75afaba78982&language=en-US&page=1")
    
    init(service: NetworkService) {
        self.service = service
    }
    
}

extension FeedRepository: FeedRepositoryProtocol {
    func getPosts(completion: @escaping () -> Void) {
        guard let url = listPath else {
//            completion(.failure(.unresolved))
            return
        }
        service.request(url: url) { (result: RequestResponse<MovieNetworkList>) in
            print(result)
//            switch result {
//            case .success(let success):
//                let posts = success.posts.map(PostCellModel.init)
//                PostPersistentAdapter.shared.generateDatabasePostObjects(from: posts)
//                completion(.success(posts))
//            case .failure(let failure):
//                let list = PostPersistentAdapter.shared.pullDatabasePostObjects()
//                let posts: [PostCellModel] = list.map { PostCellModel(from: $0) }
//                if list.isEmpty {
//                    completion(.failure(failure))
//                } else {
//                    completion(.success(posts))
//                }
//            }
        }
    }
}

