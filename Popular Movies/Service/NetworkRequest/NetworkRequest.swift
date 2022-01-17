//
//  NetworkRequest.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Alamofire

protocol NetworkRequestProtocol {
    func GET<T: Decodable>(endPoint: EndPoint,
                           completion: @escaping (Result<T, CustomError>) -> Void)
}

final class NetworkRequest {}

extension NetworkRequest: NetworkRequestProtocol {
    func GET<T: Decodable>(endPoint: EndPoint,
                           completion: @escaping (Result<T, CustomError>) -> Void) {
        print(endPoint.fullURLString())
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
