//
//  ServerError.swift
//  Popular Movies
//
//  Created by Никита Дубовик on 17.01.2022.
//

import Foundation

struct ServerErrorModel: Decodable {
    var message: String?
    var code: Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "status_message"
        case code = "status_code"
    }
}
