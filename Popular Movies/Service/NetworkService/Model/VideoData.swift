//
//  VideoData.swift
//  Popular Movies
//
//  Created by devmac on 20.01.2022.
//

import Foundation

struct VideoDataContainer: Codable {
    var results: [VideoData]
}

struct VideoData: Codable {
    var key: String
    var type: String
}
