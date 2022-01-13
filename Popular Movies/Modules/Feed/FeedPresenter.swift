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
    func paginateMovieList()
    func search(text: String)
}

final class FeedPresenter {
    weak var view: FeedViewProtocol?
    private let router: FeedRouterProtocol
    private let repository: FeedRepositoryProtocol
    
    private var movies = [MovieCellItem]()
    private var isLoading = false
    private var pageToLoad = 1
    
    init(view: FeedViewProtocol,
         router: FeedRouterProtocol,
         repository: FeedRepositoryProtocol) {
        self.view = view
        self.router = router
        self.repository = repository
    }
    
    private func fetchMovies() {
        repository.fetchMovies(keyword: nil, page: pageToLoad) { [weak self] result in
//            print("Page: \(self?.pageToLoad)")
            switch result {
            case .success(let movieList):
                self?.movies += movieList
                self?.view?.updateView()
                self?.pageToLoad += 1
                self?.isLoading = false
            default:
                break
            }
        }
    }
}

extension FeedPresenter: FeedPresenterProtocol {
    func search(text: String) {
    }
    
    func paginateMovieList() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                self.fetchMovies()
            }
        }
    }
    
    func getMovieItemForCell(at index: Int) -> MovieCellItem {
        print(movies[index])
        return movies[index]
    }
    
    var movieListCount: Int {
        movies.count
    }
    
    func configureView() {
        fetchMovies()
    }
}
