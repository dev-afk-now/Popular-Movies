//
//  CustomError.swift
//  Popular Movies
//
//  Created by Никита Дубовик on 17.01.2022.
//

import Alamofire

struct CustomError: Error {
    var message: String?
    var code: Int?
    
    init(with serverError: ServerErrorModel?) {
        guard let error = serverError else {
            return
        }
        self.message = error.message
        self.code = error.code
    }
    
    init(with afError: AFError?) {
        guard let error = afError else {
            return
        }
        self.message = error.localizedDescription
        self.code = error._code
    }
    
    init(message: String) {
        self.message = message
    }
}
