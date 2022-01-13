//
//  Endp oint.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Alamofire
//
//enum EndPoint {
//    case popularMovies(page: Int)
//    case backdropImage(path: String)
//    case posterImage(path: String)
//    case keyword(String,Int)
//
//    var apiKey: String {
//        return "?api_key=748bef7b95d85a33f87a75afaba78982"
//    }
//
//    var endPoint: URL? {
//        switch self {
//        case .popularMovies(let page):
//            return URL(string:  String(format: "\(baseURL)movie/popular%@%@%@%d", apiKey, language, pagePath, page))
//        case .backdropImage(let path):
//            return URL(string:  baseBackdropURL + path)
//        case .posterImage(let path):
//            return URL(string: basePosterURL + path)
//        case .keyword(let keyword, let page):
//            return URL(string:  String(format: "\(baseURL)search/movie%@%@%@%@%@%d", apiKey, language, queryPath, keyword, pagePath, page))
//        }
//    }
////https://api.themoviedb.org/3/search/movie?api_key=2acecb82244a02d497dc7c5aacf05014&language=en-US&query=James&page=1
//
//    var baseBackdropURL: String {
//        return "https://image.tmdb.org/t/p/w300/"
//    }
//
//    var basePosterURL: String {
//        return "https://image.tmdb.org/t/p/w500/"
//    }
//
//    var baseURL: String {
//        return "https://api.themoviedb.org/3/"
//    }
//
//    var language: String {
//        return "&language=en-US"
//    }
//
//    var queryPath: String {
//        return "&query="
//    }
//
//    var pagePath: String {
//        return "&page="
//    }
//}https://image.tmdb.org/t/p/w500/1Rr5SrvHxMXHu5RjKpaMba8VTzi.jpg

struct Constants {
    static let baseImageURL = "https://image.tmdb.org/t/p/w500/"
    static let baseURL = "https://api.themoviedb.org/3/"
    static let apiKey = "748bef7b95d85a33f87a75afaba78982"
    static let language = "en-US"
}

enum EndPoint {
    case popular(page: Int)
    case searchMovies(query: String, page: Int)
    case posterImage(path: String)
    
    var path: String {
        switch self {
        case .popular:
            return "movie/popular"
        case .searchMovies:
            return "search/movie"
        case .posterImage:
            return "t/p/w500/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .popular,
                .searchMovies,
                .posterImage:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .popular,
                .searchMovies:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .popular(page: let page):
            return ["page": page]
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
