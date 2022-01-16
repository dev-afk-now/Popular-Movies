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
        let requestService = NetworkRequest()
        let networkService = NetworkService(requestService: requestService)
        let imageRequest = ImageRequestImplementation()
        let imageService = ImageServiceImplementation(requestService: imageRequest)
        let repository = FeedRepository(networkService: networkService,
                                        imageService: imageService)
        let presenter = FeedPresenter(view: view,
                                      router: router,
                                      repository: repository)
        view.presenter = presenter
        let navigationVC = BaseNavigationController(rootViewController: view)
        return navigationVC
    }
}
