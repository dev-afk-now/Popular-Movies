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
    func fetchVideo(by id: Int,
                    completion: @escaping(VideoData?) -> ())
}

final class DetailRepository {}

extension DetailRepository: DetailRepositoryProtocol {
    func fetchVideo(by id: Int,
                    completion: @escaping (VideoData?) -> ()) {
        let endPoint: EndPoint = .videos(movieId: id)
        NetworkService.shared.request(endPoint: endPoint) {
            (result: Result<VideoDataContainer, CustomError>) in
            switch result {
            case .success(let videoObject):
                print(videoObject)
                completion(videoObject.results.first { $0.type == "Trailer" })
            default:
                break
            }
        }
    }
    
    func fetchMovie(by id: Int,
                    completion: @escaping(Result<DetailModel,
                                          CustomError>) -> ()) {
        let endPoint: EndPoint = .detail(movieId: id)
        NetworkService.shared.request(endPoint: endPoint) {
            (result: Result<NetworkDetailData, CustomError>) in
            switch result {
            case .success(let movieObject):
                completion(.success(DetailModel(with: movieObject)))
            default:
                break
            }
        }
    }
}
