//
//  NetworkRequest.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation
import Alamofire

protocol NetworkRequestProtocol {
    func GET<T: Decodable>(url: URL, completion: @escaping (Result<T, CustomError>) -> Void)
}

final class NetworkRequest {
}

extension NetworkRequest: NetworkRequestProtocol {
    func GET<T>(url: URL, completion: @escaping (Result<T, CustomError>) -> Void) where T : Decodable {
        AF.request(url, method: .get, parameters: [:], encoding: URLEncoding.default).responseData { response in
            let customError = CustomError(with: response.error)
            switch response.result {
            case .success(let data):
                do {
                    let data = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    do {
                        let serverError = try JSONDecoder().decode(ServerErrorModel.self, from: data)
                        completion(.failure(CustomError.init(with: serverError)))
                    } catch {
                        completion(.failure(CustomError(message: "Parsing Error")))
                    }
                }
            case .failure:
                completion(.failure(customError))
            }
        }
    }
}


