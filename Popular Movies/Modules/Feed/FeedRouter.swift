//
//  FeedRouter.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import UIKit

protocol FeedRouterProtocol: AnyObject {
    func showDetail(_ id: Int)
}

final class FeedRouter {
    
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension FeedRouter: FeedRouterProtocol {
    func showDetail(_ movieId: Int) {
        let module = DetailConfigurator.create(movieId: movieId)
        self.context.navigationController?.pushViewController(module, animated: true)
    }
}
