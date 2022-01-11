//
//  FeedRouter.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import UIKit

protocol FeedRouterProtocol: AnyObject {
}

final class FeedRouter {
    
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension FeedRouter: FeedRouterProtocol{
}
