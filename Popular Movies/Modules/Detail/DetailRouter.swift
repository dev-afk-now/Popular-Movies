//
//  DetailRouter.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import UIKit

protocol DetailRouterProtocol: AnyObject {
    func  closeCurrentViewController()
}

final class DetailRouter {
    
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension DetailRouter: DetailRouterProtocol {
    func closeCurrentViewController() {
        context.navigationController?.popViewController(animated: true)
    }
}
