//
//  DetailConfigurator.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import UIKit

final class DetailConfigurator {
    static func create(movieId: Int) -> UIViewController {
        let view = DetailViewController()
        let repository = DetailRepository()
        let router = DetailRouter(context: view)
        let presenter = DetailPresenter(view: view,
                                        router: router,
                                        repository: repository,
                                        movieId: movieId)
        view.presenter = presenter
        return view
    }
}
