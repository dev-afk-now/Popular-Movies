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
    private let repository: DetailRepositoryProtocol
    private let movieId: Int
    
    init(view: DetailViewProtocol,
         router: DetailRouterProtocol,
         repository: DetailRepositoryProtocol,
         movieId: Int) {
        self.view = view
        self.router = router
        self.repository = repository
        self.movieId = movieId
    }
    
    private func fetchMovie(by movieId: Int,
                            completion: EmptyBlock?) {
        repository.fetchMovie(by: movieId) { result in
            print(result)
            completion?()
        }
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func configureView() {
        fetchMovie(by: movieId) {
            //
        }
    }
}
