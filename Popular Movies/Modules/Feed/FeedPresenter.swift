//
//  FeedPresenter.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

typealias EmptyBlock = () -> Void

import Foundation

protocol FeedPresenterProtocol: AnyObject {
    var movieListCount: Int { get }
    var sortOptionsString: [String] { get }
    var selectedSortOptionIndex: Int? { get }
    func configureView()
    func getMovieItemForCell(at index: Int) -> MovieCellItem
    func loadMoreData()
    func search(text: String)
    func sortMovies(with sortOptionString: String)
    func movieItemSelected(at index: Int)
}

final class FeedPresenter {
    weak var view: FeedViewProtocol?
    private let router: FeedRouterProtocol
    private let repository: FeedRepositoryProtocol
    
    private var searchText: String = ""
    
    private var searchTask: DispatchWorkItem?
    private var searchedResults = [MovieCellItem]()
    
    private var isSearching: Bool {
        return !searchText.isEmpty
    }
    
    private var selectedSortOption: SortOption = .mostPopular
    
    private var pageToLoad = 1
    
    private var isLoading = false
    
    private var popularMovies = [MovieCellItem]()
    private var moviesDataSource: [MovieCellItem] {
        isSearching ? searchedResults : popularMovies
    }
    
    init(view: FeedViewProtocol,
         router: FeedRouterProtocol,
         repository: FeedRepositoryProtocol) {
        self.view = view
        self.router = router
        self.repository = repository
    }
    
    private func fetchPopularMovies(completion: EmptyBlock? = nil) {
        repository.fetchPopular(page: pageToLoad,
                                sortBy: selectedSortOption.rawValue) { [weak self] result in
            switch result {
            case .success(let movieList):
                self?.popularMovies += movieList
                self?.pageToLoad += 1
                self?.isLoading = false
                completion?()
            case .failure:
                self?.view?.showError()
            }
        }
    }
    
    private func fetchMovieByKeyword(searchText: String,
                                     completion: EmptyBlock? = nil) {
        repository.searchMovies(keyword: searchText,
                                page: pageToLoad) { [weak self] result in
            switch result {
            case .success(let movieList):
                self?.searchedResults += movieList
                self?.pageToLoad += 1
                self?.isLoading = false
                completion?()
            case .failure:
                self?.view?.showError()
            }
        }
    }
    
    private func updateView() {
        view?.updateView()
    }
    
    private func executeSearch(with text: String) {
        pageToLoad = 1
        searchedResults.removeAll()
        if text.isEmpty {
            breakSearch(of: searchTask)
            return
        }
        if text.count < 2 {
            return
        }
        updateView()
        searchTask?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.fetchMovieByKeyword(searchText: text) {
                self?.updateView()
            }
        }
        searchTask = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1,
                                      execute: workItem)
    }
    
    private func breakSearch(of dispatchWorkItem: DispatchWorkItem?) {
        dispatchWorkItem?.cancel()
        fetchPopularMovies(completion: updateView)
    }
    
    private func fetchMovieGenres(completion: @escaping () -> () = { }) {
        repository.fetchMovieGenres(completion: completion)
    }
}

extension FeedPresenter: FeedPresenterProtocol {
    func movieItemSelected(at index: Int) {
        router.showDetail(moviesDataSource[index].id)
    }
    
    var selectedSortOptionIndex: Int? {
        sortOptionsString.firstIndex(of: selectedSortOption.message)
    }
    
    func sortMovies(with stringOption: String) {
        let pickedOption = SortOption.allCases.first { $0.message == stringOption }
        guard let option = pickedOption else { return }
        popularMovies.removeAll()
        pageToLoad = 1
        selectedSortOption = option
        fetchPopularMovies(completion: updateView)
    }
    
    var sortOptionsString: [String] {
        SortOption.allCases.map{ $0.message }
    }
    
    func search(text: String) {
        searchText = text
        executeSearch(with: text)
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            if isSearching {
                self.fetchMovieByKeyword(searchText: searchText,
                                         completion: updateView)
            } else {
                self.fetchPopularMovies(completion: updateView)
            }
        }
    }
    
    func getMovieItemForCell(at index: Int) -> MovieCellItem {
        return moviesDataSource[index]
    }
    
    var movieListCount: Int {
        moviesDataSource.count
    }
    
    func configureView() {
        let group = DispatchGroup()
        let requests = [fetchMovieGenres,
                        fetchPopularMovies]
        
        for item in requests {
            group.enter()
            item {
                print(String(describing: item))
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.updateView()
        }
    }
}
