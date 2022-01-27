//
//  FeedPresenter.swift
//  Popular Movies
//
//  Created by devmac on 11.01.2022.
//

import Foundation

typealias EmptyBlock = () -> Void

protocol FeedPresenterProtocol: AnyObject {
    var movieListCount: Int { get }
    var sortOptionsString: [String] { get }
    var selectedSortOptionIndex: Int? { get }
    func setContent()
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
    
    private var isSearchActive: Bool {
        !searchText.isEmpty
    }
    
    private var selectedSortOption: SortOption = .mostPopular
    
    private var pageToLoad = 1
    
    private var isLoading = false
    private var isReachable = true
    
    private var totalResults = 0
    private var fullMovies = [MovieCellItem]()
    private var moviesDataSource: [MovieCellItem] {
        isSearchActive ? searchedResults : fullMovies
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
        guard (movieListCount < totalResults) || totalResults == .zero else { return }
        isLoading = true
        repository.fetchPopular(page: pageToLoad,
                                sortBy: selectedSortOption.rawValue) { [weak self] result in
            switch result {
            case .success(let movieContainer):
                self?.fullMovies += movieContainer.movies
                self?.pageToLoad += 1
                self?.totalResults = movieContainer.totalMovies
                self?.internalUpdateView()
                completion?()
            case .failure:
                self?.view?.hideLoading()
                completion?()
            }
        }
    }
    
    private func fetchMovieByKeyword(searchText: String,
                                     completion: EmptyBlock? = nil) {
        guard (movieListCount < totalResults) || totalResults == .zero  else { return }
        isLoading = true
        repository.searchMovies(keyword: searchText,
                                page: pageToLoad) { [weak self] result in
            switch result {
            case .success(let movieContainer):
                self?.searchedResults += movieContainer.movies
                self?.pageToLoad += 1
                self?.totalResults = movieContainer.totalMovies
                self?.view?.showNoResultsIfNeeded(movieContainer.movies.isEmpty)
                self?.internalUpdateView()
                completion?()
            case .failure:
                self?.view?.hideLoading()
                completion?()
            }
        }
    }
    
    private func internalUpdateView() {
        view?.updateView()
        view?.hideLoading()
        isLoading = false
    }
    
    private func performLocalSearch(with text: String) {
        searchedResults = fullMovies.filter { $0.title.contains(text) }
        internalUpdateView()
    }
    
    private func executeSearch(with text: String) {
        clearSearch()
        view?.showLoading()
        if text.isEmpty {
            breakSearch()
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
    
    private func breakSearch() {
        searchTask?.cancel()
    }
    
    private func fetchMovieGenres(completion: EmptyBlock? = nil) {
        repository.fetchMovieGenres(completion: completion)
    }
    
    private func fetchSavedMovies(completion: EmptyBlock? = nil) {
        fullMovies.removeAll()
        repository.fetchDataBaseObjects { movieContainer in
            self.fullMovies = movieContainer.movies
            self.internalUpdateView()
            completion?()
        }
    }
    
    private func clearSearch() {
        searchedResults.removeAll()
        pageToLoad = 1
        internalUpdateView()
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
    @objc private func connectionDisappeared() {
        isReachable = false
        fetchSavedMovies()
    }
    
    @objc private func connectionAppeared() {
        isReachable = true
        loadMoreData()
    }
}

// MARK: - Extension -
extension FeedPresenter: FeedPresenterProtocol {
    func movieItemSelected(at index: Int) {
        searchTask?.cancel()
        router.showDetail(moviesDataSource[index].id)
    }
    
    var selectedSortOptionIndex: Int? {
        sortOptionsString.firstIndex(of: selectedSortOption.message)
    }
    
    func sortMovies(with stringOption: String) {
        let pickedOption = SortOption.allCases.first { $0.message == stringOption }
        guard isReachable,
              let option = pickedOption,
              pickedOption != selectedSortOption else { return }
        fullMovies.removeAll()
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
        if !isLoading, isReachable {
            isLoading = true
            if isSearchActive {
                fetchMovieByKeyword(searchText: searchText)
            } else {
                fetchPopularMovies()
            }
        }
    }
    
    func getMovieItemForCell(at index: Int) -> MovieCellItem {
        return moviesDataSource[index]
    }
    
    var movieListCount: Int {
        moviesDataSource.count
    }
    
    func setContent() {
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
