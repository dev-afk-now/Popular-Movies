//
//  DetailRepository.swift
//  Popular Movies
//
//  Created by Никита Дубовик on 18.01.2022.
//

import Foundation

protocol DetailRepositoryProtocol {
    func fetchMovie(by id: Int,
                    completion: @escaping(Result<DetailModel,
                                          CustomError>) -> ())
}

final class DetailRepository {}

extension DetailRepository: DetailRepositoryProtocol {
    func fetchMovie(by id: Int,
                    completion: @escaping(Result<DetailModel,
                                          CustomError>) -> ()) {
        let endPoint: EndPoint = .detail(movieId: id)
        NetworkService.shared.request(endPoint: endPoint) {
            (result: Result<NetworkDetailData, CustomError>) in
            switch result {
            case .success(let movieObject):
                print(movieObject)
                completion(.success(DetailModel(with: movieObject)))
            default:
                break
            }
        }
    }
}
