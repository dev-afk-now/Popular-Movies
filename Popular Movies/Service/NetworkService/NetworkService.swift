//
//  NetworkService.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(url: URL?, completion: @escaping (Result<T, CustomError>) -> Void)
}

final class NetworkService {
    private let requestService: NetworkRequestProtocol!
    
    init(requestService: NetworkRequestProtocol) {
        self.requestService = requestService
    }
}

extension NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(url: URL?, completion: @escaping (Result<T, CustomError>) -> Void) {
        guard let url = url else {
            return
        }
        requestService.GET(url: url) { (result: Result<T, CustomError>) -> Void in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}


struct RequestResponse<T: Decodable>: Decodable {
    var results: T?
    var error: ServerErrorModel?
}

struct ServerErrorModel: Decodable {
    var message: String?
    var code: Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "status_message"
        case code = "status_code"
    }
}

struct CustomError: Error {
    var message: String?
    var code: Int?
    
    init(with serverError: ServerErrorModel?) {
        guard let error = serverError else {
            return
        }
        self.message = error.message
        self.code = error.code
    }
    
    init(with afError: AFError?) {
        guard let error = afError else {
            return
        }
        self.message = error.localizedDescription
        self.code = error._code
    }
    
    init(message: String) {
        self.message = message
    }
}
