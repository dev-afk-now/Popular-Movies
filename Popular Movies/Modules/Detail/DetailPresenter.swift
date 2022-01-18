//
//  DetailPresenter.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import UIKit

protocol DetailPresenterProtocol: AnyObject {
    func configureView()
}

final class DetailPresenter {
    weak private var view: DetailViewProtocol?
    private let router: DetailRouterProtocol
    private let id: Int
    
    init(view: DetailViewProtocol,
         router: DetailRouterProtocol,
         id: Int) {
        self.view = view
        self.router = router
        self.id = id
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func configureView() {
        
    }
}
