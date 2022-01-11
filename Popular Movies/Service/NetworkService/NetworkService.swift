//
//  NetworkService.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation
import Alamofire

protocol NetworkService {
    func request<T: Decodable>(url: URL?, completion: @escaping (RequestResponse<T>) -> Void)
}

final class NetworkServiceImplementation {
    
    enum Error: Swift.Error {
        case propagated(Swift.Error)
        case offlined
        case timeOut
    }
    
    // TODO: Move to endPoint
    
    private var listPath = "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/main.json"
    private var basicPath = "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/posts/[id].json"
    private let requestService: NetworkRequest!
    
    
    init(requestService: NetworkRequest) {
        self.requestService = requestService
    }
}

extension NetworkServiceImplementation: NetworkService {
    func request<T: Decodable>(url: URL?, completion: @escaping (RequestResponse<T>) -> Void) {
        guard let url = url else {
            return
        }

        requestService.GET(url: url) { (result: MovieNetworkList?) -> Void in
            
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
}

struct CustomError {
    
    var message: String?
    var code: Int?
    
    init(with serverError: ServerErrorModel?) {
        guard let error = serverError else {
            self.message = "Something went wrong"
            return
        }
        self.message = error.message
        self.code = error.code
    }
    
    init(with afError: AFError?) {
        guard let error = afError else {
            self.message = "Something went wrong"
            return
        }
        self.message = error.localizedDescription
        self.code = error._code
    }
    
    init(message: String) {
        self.message = message
    }
}
