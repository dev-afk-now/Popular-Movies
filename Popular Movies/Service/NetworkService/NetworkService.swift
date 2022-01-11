//
//  NetworkService.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

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
        
        requestService.GET(url: url, completion: completion)
    }
}

struct RequestResponse<T: Decodable> {
    var data: T?
    var error: NetworkRequestImplementation.Error?
}
