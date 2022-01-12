//
//  FeedPresenter.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

protocol FeedPresenterProtocol: AnyObject {
    var movieListCount: Int { get }
    func configureView()
    func getMovieItemForCell(at index: Int) -> MovieCellItem
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
    func getMovieItemForCell(at index: Int) -> MovieCellItem {
        return movies[index]
    }
    
    var movieListCount: Int {
        movies.count
    }
    
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
