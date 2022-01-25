//
//  DetailPresenter.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import UIKit

protocol DetailPresenterProtocol: AnyObject {
    var cellDataSource: [DetailCellType] { get }
    var trailerPath: String { get }
    func configureView()
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
    
    private var cellsToDraw = [DetailCellType]()
    
    // MARK: - Init -
    init(view: DetailViewProtocol,
         router: DetailRouterProtocol,
         repository: DetailRepositoryProtocol,
         movieId: Int) {
        self.view = view
        self.router = router
        self.repository = repository
        self.movieId = movieId
        prepareCellDataSource()
    }
    
    // MARK: - Private properties -
    private func prepareCellDataSource() {
        let cellList: [DetailCellType] = [.headlineCell,
                                          .trailerCell,
                                          .descriptionCell
                                          ]
        cellsToDraw = cellList
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
    
    private func fetchVideo(completion: EmptyBlock?) {
        repository.fetchVideo(by: movieId) { [weak self] videoData in
            self?.trailerDataSource = videoData
            completion?()
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
        return cellsToDraw
    }
    
    func closeButtonTapped() {
        return router.closeCurrentViewController()
    }
    
    func getMovieData() -> DetailModel? {
        return movieDataSource
    }
    
    func configureView() {
        let group = DispatchGroup()
        let requests = [fetchMovie, fetchVideo]
        
        for item in requests {
            group.enter()
            item {
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.view?.updateView()
        }
    }
}
