//
//  DetailConfigurator.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import UIKit

final class DetailConfigurator {
    static func create() -> UIViewController {
        let view = DetailViewController()
        let router = DetailRouter(context: view)
        let presenter = DetailPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
}
