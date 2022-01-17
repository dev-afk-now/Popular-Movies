//
//  FeedPresenter.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

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
    
    private func fetchPopularMovies() {
        print("start popular")
        repository.fetchPopular(page: pageToLoad,
                                sortBy: selectedSortOption.rawValue) { [weak self] result in
            switch result {
            case .success(let movieList):
                self?.popularMovies += movieList
                self?.view?.updateView()
                self?.pageToLoad += 1
                self?.isLoading = false
                print("finish popular")
            case .failure:
                self?.view?.showError()
            }
        }
    }
    
    private func fetchMovieByKeyword(searchText: String) {
        repository.searchMovies(keyword: searchText,
                                page: pageToLoad) { [weak self] result in
            switch result {
            case .success(let movieList):
                self?.searchedResults += movieList
                self?.view?.updateView()
                self?.pageToLoad += 1
                self?.isLoading = false
            case .failure:
                self?.view?.showError()
            }
        }
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
        searchTask?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.fetchMovieByKeyword(searchText: text)
        }
        searchTask = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1,
                                      execute: workItem)
    }
    
    private func breakSearch(of dispatchWorkItem: DispatchWorkItem?) {
        dispatchWorkItem?.cancel()
        fetchPopularMovies()
    }
    
    private func fetchMovieGenres() {
        repository.fetchMovieGenres()
    }
}

extension FeedPresenter: FeedPresenterProtocol {
    var selectedSortOptionIndex: Int? {
        sortOptionsString.firstIndex(of: selectedSortOption.message)
    }
    
    func sortMovies(with stringOption: String) {
        let pickedOption = SortOption.allCases.first { $0.message == stringOption }
        guard let option = pickedOption else { return }
        popularMovies.removeAll()
        pageToLoad = 1
        selectedSortOption = option
        fetchPopularMovies()
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
                self.fetchMovieByKeyword(searchText: searchText)
            } else {
                self.fetchPopularMovies()
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
        DispatchQueue.global(qos: .background).async(group: group) { [weak self] in
            guard let strongSelf = self else { return }
            group.enter()
            strongSelf.fetchMovieGenres()
            strongSelf.fetchPopularMovies()
            group.leave()
        }
    }
}
