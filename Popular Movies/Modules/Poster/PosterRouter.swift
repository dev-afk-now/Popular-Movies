//
//  PosterRouter.swift
//  Popular Movies
//
//  Created by devmac on 21.01.2022.
//

import UIKit

protocol PosterRouterProtocol: AnyObject {
}

final class PosterRouter {
    
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension PosterRouter: PosterRouterProtocol {
}
