//
//  PosterPresenter.swift
//  Popular Movies
//
//  Created by devmac on 21.01.2022.
//

import UIKit

protocol PosterPresenterProtocol: AnyObject {
    func configureView()
    func closeView()
}

final class PosterPresenter {
    weak private var view: PosterViewProtocol?
    private let router: PosterRouterProtocol
    
    private let imageData: Data
    
    init(view: PosterViewProtocol,
         router: PosterRouterProtocol,
         imageData: Data) {
        self.view = view
        self.router = router
        self.imageData = imageData
        configureView()
    }
}

extension PosterPresenter: PosterPresenterProtocol {
    func closeView() {
        router.closeCurrentViewController()
    }
    
    func configureView() {
        view?.updateImageView(imageData: imageData)
    }
}
