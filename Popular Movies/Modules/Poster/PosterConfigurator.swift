//
//  PosterConfigurator.swift
//  Popular Movies
//
//  Created by devmac on 21.01.2022.
//

import UIKit

final class PosterConfigurator {
    static func create(imageData: Data) -> UIViewController {
        let view = PosterViewController()
        let router = PosterRouter(context: view)
        let presenter = PosterPresenter(view: view,
                                        router: router,
                                        imageData: imageData)
        view.presenter = presenter
        let navigationVC = UINavigationController(rootViewController: view)
        return navigationVC
    }
}
