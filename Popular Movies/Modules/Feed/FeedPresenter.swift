//
//  FeedPresenter.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

protocol FeedPresenterProtocol: AnyObject {
    
}

final class FeedPresenter {
    weak var view: FeedViewProtocol?
    private let router: FeedRouterProtocol?
    
    init(view: FeedViewProtocol, router: FeedRouterProtocol) {
        self.view = view
        self.router = router
    }
}

extension FeedPresenter: FeedPresenterProtocol {
    
}
