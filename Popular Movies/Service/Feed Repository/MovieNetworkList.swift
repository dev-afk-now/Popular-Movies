//
//  MovieNetworkItem.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

struct MovieNetworkList: Codable {
    var results: [MovieNetworkItem]
}

struct MovieNetworkItem: Codable {
    var original_title: String
}
