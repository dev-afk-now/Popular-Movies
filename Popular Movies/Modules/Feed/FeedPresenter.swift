//
//  FeedPresenter.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

//https://api.themoviedb.org/3/movie/popular?api_key=748bef7b95d85a33f87a75afaba78982&language=en-US&page=1

protocol FeedPresenterProtocol: AnyObject {
    func configureView()
}

final class FeedPresenter {
    weak var view: FeedViewProtocol?
    private let router: FeedRouterProtocol
    private let repository: FeedRepositoryProtocol
    
    private var movies = [MovieCellItem]()
    
    init(view: FeedViewProtocol,
         router: FeedRouterProtocol,
         repository: FeedRepositoryProtocol) {
        self.view = view
        self.router = router
        self.repository = repository
    }
}

extension FeedPresenter: FeedPresenterProtocol {
    func configureView() {
        repository.fetchMovies { [weak self] result in
            switch result {
            case .success(let movieList):
                self?.movies = movieList
                self?.view?.updateView()
            case .failure(let failure):
                self?.view?.showError(failure.message ?? "")
            }
        }
    }
}
