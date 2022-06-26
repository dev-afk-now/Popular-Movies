//
//  DetailRouter.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import UIKit

protocol DetailRouterProtocol: AnyObject {
    func closeCurrentViewController()
    func showPoster(with imageData: Data)
}

final class DetailRouter {
    
    unowned let context: UIViewController
    
    init(context: UIViewController) {
        self.context = context
    }
}

extension DetailRouter: DetailRouterProtocol {
    func showPoster(with imageData: Data) {
        let module = PosterConfigurator.create(imageData: imageData)
        module.modalPresentationStyle = .overFullScreen
        context.present(module, animated: true)
    }
    
    func closeCurrentViewController() {
        context.navigationController?.popViewController(animated: true)
    }
}
