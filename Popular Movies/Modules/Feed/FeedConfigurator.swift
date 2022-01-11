//
//  FeedConfigurator.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import UIKit

final class FeedConfigurator {
    static func create() -> UIViewController {
        let view = FeedViewController()
        let router = FeedRouter(context: view)
        let presenter = FeedPresenter(view: view, router: router)
        view.presenter = presenter
        let navigationVC = BaseNavigationController(rootViewController: view)
        return navigationVC
    }
}
