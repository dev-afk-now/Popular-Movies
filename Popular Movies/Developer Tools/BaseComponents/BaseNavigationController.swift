//
//  BaseNavigationController.swift
//  PopularMovies.demo
//
//  Created by devmac on 14.12.2021.
//

import UIKit

final class BaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}
