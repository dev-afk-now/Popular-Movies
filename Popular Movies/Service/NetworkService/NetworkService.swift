//
//  NetworkService.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endPoint: EndPoint,
                               completion: @escaping (Result<T, CustomError>) -> ())
}

final class NetworkService {
    private static let shared = NetworkService()
    
    private init() {}
}

extension NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(endPoint: EndPoint,
                               completion: @escaping (Result<T, CustomError>) -> ()) {
        AF.request(endPoint.fullURLString(),
                   method: endPoint.method,
                   parameters: endPoint.parameters,
                   encoding: endPoint.encoding).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let parsedObject = try JSONDecoder().decode(T.self, from: data)
                    print(parsedObject)
                    completion(.success(parsedObject))
                } catch {
                    do {
                        let serverError = try JSONDecoder().decode(ServerErrorModel.self, from: data)
                        completion(.failure(CustomError.init(with: serverError)))
                    } catch {
                        completion(.failure(CustomError(message: "Parsing Error")))
                    }
                }
            case .failure:
                completion(.failure(.init(with: response.error)))
            }
        }
    }
}
