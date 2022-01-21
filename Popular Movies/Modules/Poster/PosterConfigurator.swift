//
//  PosterConfigurator.swift
//  Popular Movies
//
//  Created by devmac on 21.01.2022.
//

import Foundation

import UIKit

final class PosterConfigurator {
    static func create() -> UIViewController {
        let view = PosterViewProtocol()
        let router = PosterRouterProtocol(context: view)
        let presenter = PosterPresenterProtocol(view: view,
                                           router: router)
        view.presenter = presenter
        let navigationVC = UINavigationController(rootViewController: view)
        return navigationVC
    }
}
