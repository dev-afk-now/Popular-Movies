//
//  DetailRepository.swift
//  Popular Movies
//
//  Created by Никита Дубовик on 18.01.2022.
//

import Foundation

protocol DetailRepositoryProtocol {
    func fetchMovie(by id: Int,
                    completion: @escaping(Result<NetworkDetailData,
                                          CustomError>) -> ())
}

final class DetailRepository {}

extension DetailRepository: DetailRepositoryProtocol {
    func fetchMovie(by id: Int,
                    completion: @escaping(Result<NetworkDetailData,
                                          CustomError>) -> ()) {
        let endPoint: EndPoint = .detail(movieId: id)
        NetworkService.shared.request(endPoint: endPoint) {
            (result: Result<NetworkDetailData, CustomError>) in
            switch result {
            case .success(let success):
                print(success.title)
                // TODO: Persistence
                completion(.success(success))
            default:
                break
            }
        }
    }
}
