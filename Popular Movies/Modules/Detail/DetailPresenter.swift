//
//  DetailPresenter.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    var cellDataSource: [DetailCellType] { get }
    var trailerPath: String { get }
    func setContent()
    func getMovieData() -> DetailModel?
    func closeButtonTapped()
    func posterImageTapped(imageData: Data?)
}

final class DetailPresenter {
    
    // MARK: - Public properties -
    weak var view: DetailViewProtocol?
    
    // MARK: - Private properties -
    private let router: DetailRouterProtocol
    private let repository: DetailRepositoryProtocol
    private let movieId: Int
    private var movieDataSource: DetailModel?
    
    private var trailerDataSource: VideoData?
    
    private var isReachable = true
    private var isLoading = false
    
    private var cellTypes = [DetailCellType]()
    
    // MARK: - LifeCycle -
    init(view: DetailViewProtocol,
         router: DetailRouterProtocol,
         repository: DetailRepositoryProtocol,
         movieId: Int) {
        self.view = view
        self.router = router
        self.repository = repository
        self.movieId = movieId
        prepareCellDataSource()
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
    
    // MARK: - Private properties -
    private func prepareCellDataSource() {
        cellTypes =  [.headlineCell,
                      .trailerCell,
                      .descriptionCell
        ]
    }
    
    private func fetchMovie(completion: EmptyBlock?) {
        repository.fetchMovie(by: movieId) { [weak self] result in
            switch result {
            case .success(let movieObject):
                self?.movieDataSource = movieObject
                completion?()
            default:
                break
            }
        }
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
    
    private func fetchVideo(completion: EmptyBlock?) {
        repository.fetchVideo(by: movieId) { [weak self] videoData in
            self?.trailerDataSource = videoData
            completion?()
        }
    }
    
    // MARK: - Actions -
    @objc private func connectionDisappeared() {
        isReachable = false
    }
    
    @objc private func connectionAppeared() {
        isReachable = true
        if isLoading {
            setContent()
        }
    }
}

// MARK: - Extension -
extension DetailPresenter: DetailPresenterProtocol {
    func posterImageTapped(imageData: Data?) {
        guard let data = imageData else { return }
        router.showPoster(with: data)
    }
    
    var trailerPath: String {
        return trailerDataSource?.key ?? ""
    }
    
    var cellDataSource: [DetailCellType] {
        return cellTypes
    }
    
    func closeButtonTapped() {
        return router.closeCurrentViewController()
    }
    
    func getMovieData() -> DetailModel? {
        return movieDataSource
    }
    
    func setContent() {
        let group = DispatchGroup()
        let requests = [fetchMovie, fetchVideo]
        isLoading = true
        
        for item in requests {
            group.enter()
            item {
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.view?.updateView()
            self?.isLoading = false
        }
    }
}
