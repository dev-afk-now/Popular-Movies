//
//  NetworkRequest.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

protocol NetworkRequest {
    func GET<T: Decodable>(url: URL, completion: @escaping (RequestResponse<T>) -> Void)
}

final class NetworkRequestImplementation {
    enum Error: Swift.Error {
        case propagated(Swift.Error)
        case offline
    }
}

extension NetworkRequestImplementation: NetworkRequest {
    
    func GET<T: Decodable>(url: URL, completion: @escaping (RequestResponse<T>) -> Void) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }
            if let error = error {
                completion(.init(data: nil, error: self.trackError(error)))
                return
            }
            guard data != nil else {
                let context = DecodingError.Context(codingPath: [], debugDescription: "data corrupted")
                completion(.init(data: nil, error: .propagated(DecodingError.dataCorrupted(context))))
                return
            }
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: data!)
                completion(.init(data: parsedData, error: nil))
            } catch let error {
                completion(.init(data: nil, error: self.trackError(error)))
            }
        }.resume()
    }
}

extension NetworkRequestImplementation: ErrorTracker { }

protocol ErrorTracker {
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
