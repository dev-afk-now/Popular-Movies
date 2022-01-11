//
//  NetworkRequest.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation
import Alamofire

protocol NetworkRequest {
    func GET<T: Decodable>(url: URL, completion: @escaping (_ response: T?) -> Void)
}

final class NetworkRequestImplementation {
    enum Error: Swift.Error {
        case propagated(Swift.Error)
        case offline
    }
}

extension NetworkRequestImplementation: NetworkRequest {
//    func GET<T>(url: URL, completion: @escaping (RequestResponse<T>?, Error?) -> Void) where T : Decodable {
//
//    }
//
    func GET<T>(url: URL, completion: @escaping (_ response: T?) -> Void) where T : Decodable {
        AF.request(url, method: .get, parameters: [:], encoding: URLEncoding.default).responseData { response in
                switch response.result {
                case .success(let data):
                    let response = try? JSONDecoder().decode(RequestResponse<T>.self, from: data)
                    let customError = CustomError(with: response?.error)
//                    completion(response?.data, customError)
                case .failure(let error):
                    print("")
//                    completion(nil, error as NSError)
                }
            }
    }
    
    
    
//    func GET<T: Decodable>(url: URL, completion: @escaping (_ response: RequestResponse<T>?,
//                                                            _ error: Error?) -> Void) {
//
////        AF.request(url, method: .get, parameters: [:], encoding: URLEncoding.default)
////            .responseData { response in
////                switch response.result {
////                case .success(let data):
////                    let response = try JSONDecoder().decode(RequestResponse<T>.self, from: data)
////                case .failure(let error):
////                    completion(nil, error)
////                }
////            }
////        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
////        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
////            guard let self = self else { return }
////            if let error = error {
////                completion(.init(data: nil, error: self.trackError(error)))
////                return
////            }
////            guard data != nil else {
////                let context = DecodingError.Context(codingPath: [], debugDescription: "data corrupted")
////                completion(.init(data: nil, error: .propagated(DecodingError.dataCorrupted(context))))
////                return
////            }
////            do {
////                let parsedData = try JSONDecoder().decode(T.self, from: data!)
////                completion(.init(data: parsedData, error: nil))
////            } catch let error {
////                completion(.init(data: nil, error: self.trackError(error)))
////            }
////        }.resume()
//    }

}

extension NetworkRequestImplementation: ErrorTracker {}

protocol ErrorTracker: Decodable {
    func trackError(_ error: Error?) -> NetworkRequestImplementation.Error?
}

extension ErrorTracker {
    func trackError(_ error: Error?) -> NetworkRequestImplementation.Error? {
        guard let error = error else {
            return nil
        }
        let nsError = error as NSError
        switch nsError.code {
        case URLError.notConnectedToInternet.rawValue:
            return .offline
        default:
            return .propagated(error)
        }
    }
}
