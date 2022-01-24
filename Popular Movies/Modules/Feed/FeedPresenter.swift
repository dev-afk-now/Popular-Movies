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
    // MARK: - Public properties -
    weak var view: FeedViewProtocol?
    
    // MARK: - Private properties -
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
    private var isReachable = true
    
    private var popularMovies = [MovieCellItem]()
    private var moviesDataSource: [MovieCellItem] {
        isSearching ? searchedResults : popularMovies
    }
    
    // MARK: - LifeCycle -
    init(view: FeedViewProtocol,
         router: FeedRouterProtocol,
         repository: FeedRepositoryProtocol) {
        self.view = view
        self.router = router
        self.repository = repository
        startRecieveConnectionNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .connectionLost,
                                                  object: ReachabilityManager.shared)
        NotificationCenter.default.removeObserver(self,
                                                  name: .connectionReastablished,
                                                  object: ReachabilityManager.shared)
    }
    
    // MARK: - Private methods -
    private func fetchPopularMovies(completion: EmptyBlock? = nil) {
        isLoading = true
        
        repository.fetchPopular(page: pageToLoad,
                                sortBy: selectedSortOption.rawValue) { [weak self] result in
            switch result {
            case .success(let movieList):
                self?.popularMovies += movieList
                self?.pageToLoad += 1
                completion?()
            default:
                completion?()
            }
        }
    }
    
    private func fetchMovieByKeyword(searchText: String,
                                     completion: EmptyBlock? = nil) {
        isLoading = true
        repository.searchMovies(keyword: searchText,
                                page: pageToLoad) { [weak self] result in
            switch result {
            case .success(let movieList):
                self?.searchedResults += movieList
                self?.pageToLoad += 1
                completion?()
            default:
                completion?()
            }
        }
    }
    
    private func internalUpdateView() {
        view?.updateView()
        view?.hideLoading()
        view?.showNoResultsIfNeeded(moviesDataSource.isEmpty)
        isLoading = false
    }
    
    private func performLocalSearch(with text: String) {
        searchedResults = popularMovies.filter{ $0.title.contains(text) }
        internalUpdateView()
    }
    
    private func executeSearch(with text: String) {
        clearSearch()
        if text.isEmpty {
            breakSearch(of: searchTask)
            return
        }
        if !isReachable {
            performLocalSearch(with: text)
            return
        }
        if text.count < 2 {
            return
        }
        searchTask?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.view?.showLoading()
            self?.fetchMovieByKeyword(searchText: text) {
                self?.internalUpdateView()
            }
        }
        searchTask = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1,
                                      execute: workItem)
    }
    
    private func breakSearch(of dispatchWorkItem: DispatchWorkItem?) {
        dispatchWorkItem?.cancel()
        clearSearch()
        internalUpdateView()
    }
    
    private func fetchMovieGenres(completion: EmptyBlock? = nil) {
        repository.fetchMovieGenres(completion: completion)
    }
    
    private func fetchSavedMovies(completion: EmptyBlock?) {
        isLoading = true
        popularMovies.removeAll()
        repository.fetchDataBaseObjects { movies in
            self.popularMovies = movies
            self.internalUpdateView()
            completion?()
        }
    }
    
    private func clearSearch() {
        searchedResults.removeAll()
        pageToLoad = 1
    }
    
    private func startRecieveConnectionNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(connectionDisappeared),
                                               name: .connectionLost,
                                               object: ReachabilityManager.shared)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(connectionAppeared),
                                               name: .connectionReastablished,
                                               object: ReachabilityManager.shared)
    }
    
    // MARK: - Actions -
    @objc func connectionDisappeared() {
        isReachable = false
        fetchSavedMovies {
            self.internalUpdateView()
        }
    }
    
    @objc func connectionAppeared() {
        isReachable = true
        loadMoreData()
    }
}

// MARK: - Extension -
extension FeedPresenter: FeedPresenterProtocol {
    func movieItemSelected(at index: Int) {
        router.showDetail(moviesDataSource[index].id)
    }
    
    var selectedSortOptionIndex: Int? {
        sortOptionsString.firstIndex(of: selectedSortOption.message)
    }
    
    func sortMovies(with stringOption: String) {
        let pickedOption = SortOption.allCases.first { $0.message == stringOption }
        guard isReachable,
              let option = pickedOption else { return }
        popularMovies.removeAll()
        pageToLoad = 1
        selectedSortOption = option
        fetchPopularMovies(completion: internalUpdateView)
    }
    
    var sortOptionsString: [String] {
        SortOption.allCases.map{ $0.message }
    }
    
    func search(text: String) {
        searchText = text
        executeSearch(with: text)
    }
    
    func loadMoreData() {
        view?.showLoading()
        if !self.isLoading, isReachable {
            self.isLoading = true
            if isSearching {
                self.fetchMovieByKeyword(searchText: searchText,
                                         completion: internalUpdateView)
            } else {
                self.fetchPopularMovies(completion: internalUpdateView)
            }
        } else {
            view?.hideLoading()
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
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.internalUpdateView()
        }
    }
}
