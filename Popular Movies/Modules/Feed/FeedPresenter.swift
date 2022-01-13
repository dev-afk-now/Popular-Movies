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
    
    private var searchTask: DispatchWorkItem?
    
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
            case .failure:
                self?.view?.showError()
            }
        }
    }
    
    private func executeSearch(with text: String) {
        if text.isEmpty {
            breakSearch(of: searchTask)
            return
        }
        if text.count < 2 {
            return
        }
        searchTask?.cancel()
        let workItem = DispatchWorkItem { [unowned self] in
            repository.fetchMovies(keyword: text,
                                   page: pageToLoad) { result in
                switch result {
                case .success(let movies):
                    self.movies = movies
                    self.view?.updateView()
                default:
                    break
                }
            }        }
        searchTask = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: workItem)
    }
    
    private func breakSearch(of dispatchWorkItem: DispatchWorkItem?) {
        dispatchWorkItem?.cancel()
        view?.updateView()
    }
}

extension FeedPresenter: FeedPresenterProtocol {
    func search(text: String) {
        executeSearch(with: text)
    }
    
    func paginateMovieList() {
        if !self.isLoading {
            self.isLoading = true
            self.fetchMovies()
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
