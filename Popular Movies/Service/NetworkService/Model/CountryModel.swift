//
//  CountryModel.swift
//  Popular Movies
//
//  Created by Никита Дубовик on 19.01.2022.
//

import Foundation

struct CountryModel: Codable {
    var code: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case code = "iso_3166_1"
    }
}
