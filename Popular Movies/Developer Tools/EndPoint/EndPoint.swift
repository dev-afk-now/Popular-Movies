//
//  Endp oint.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Alamofire
//https://api.themoviedb.org/3/movie/550?api_key=748bef7b95d85a33f87a75afaba78982&language=en-US
struct Constants {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let apiKey = "748bef7b95d85a33f87a75afaba78982"
    static let language = "en-US"
}

enum EndPoint {
    case popular(page: Int, sortBy: String)
    case searchMovies(query: String, page: Int)
    case genres
    case detail(movieId: Int)
    
    var path: String {
        switch self {
        case .popular:
            return "discover/movie"
        case .searchMovies:
            return "search/movie"
        case .genres:
            return "genre/movie/list"
        case .detail(let movieID):
            return "movie/\(movieID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .popular,
                .searchMovies,
                .genres,
                .detail:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .popular,
                .searchMovies,
                .genres,
                .detail:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .popular(page: let page, sortBy: let sortBy):
            return ["sort_by": sortBy,
                    "page": page]
        case .searchMovies(query: let query, page: let page):
            return ["query": query,
                    "page": page]
        default:
            return [:]
        }
    }
    
    func fullURLString() -> String {
        return String(format: "%@%@?api_key=%@&language=%@",
                      Constants.baseURL,
                      self.path,
                      Constants.apiKey,
                      Constants.language)
    }
}
