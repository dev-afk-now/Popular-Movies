//
//  PosterPresenter.swift
//  Popular Movies
//
//  Created by devmac on 21.01.2022.
//

import Foundation

protocol PosterPresenterProtocol: AnyObject {
    func setContent()
    func closeView()
}

final class PosterPresenter {
    weak var view: PosterViewProtocol?
    private let router: PosterRouterProtocol
    
    private let imageData: Data
    
    init(view: PosterViewProtocol,
         router: PosterRouterProtocol,
         imageData: Data) {
        self.view = view
        self.router = router
        self.imageData = imageData
    }
}

extension PosterPresenter: PosterPresenterProtocol {
    func closeView() {
        router.closeCurrentViewController()
    }
    
    func setContent() {
        view?.updateImageView(imageData: imageData)
    }
}
