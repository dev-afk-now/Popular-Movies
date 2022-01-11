//
//  Endp oint.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

enum Endpoint {
    case popularMovies(page: Int)
    case backdropImage(path: String)
    case posterImage(path: String)
    
    var apiKey: String {
        return "?api_key=748bef7b95d85a33f87a75afaba78982"
    }
    
    var endPoint: String {
        switch self {
        case .popularMovies(let page):
            return basicURL + "movie/popular?" + apiKey + pagePath + "\(page)"
        case .backdropImage(let path):
            return basicBackdropURL + path
        case .posterImage(let path):
            return basicPosterURL + path
        }
    }
    
    var basicBackdropURL: String {
        return "https://image.tmdb.org/t/p/w300/"
    }
    
    var basicPosterURL: String {
        return "https://image.tmdb.org/t/p/w500/"
    }
    
    var basicURL: String {
        return "https://api.themoviedb.org/3/"
    }
    
    var language: String {
        return "&language=en-US"
    }
    
    var pagePath: String {
        return "&page="
    }
}
