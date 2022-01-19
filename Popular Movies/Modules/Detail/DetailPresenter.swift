//
//  DetailPresenter.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import UIKit

enum DetailCellType {
    case headlineCell
    case genresCell
    case ratingCell
    case descriptionCell
}

struct DetailSectionModel {
    let cells: [DetailCellType]
}

protocol DetailPresenterProtocol: AnyObject {
    func configureView()
    func getMovieData() -> DetailModel?
    func closeButtonTapped()
    var cellDataSource: [DetailCellType] { get }
}

final class DetailPresenter {
    weak private var view: DetailViewProtocol?
    private let router: DetailRouterProtocol
    private let repository: DetailRepositoryProtocol
    private let movieId: Int
    private var movieDataSource: DetailModel?
    
    private var cellsToDrow = [DetailCellType]()
    
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
    
    private func prepareCellDataSource() {
        let cellList: [DetailCellType] = [.headlineCell,
                                          .genresCell,
                                          .ratingCell,
                                          .descriptionCell]
        cellsToDrow = cellList
    }
    
    private func fetchMovie(by movieId: Int,
                            completion: EmptyBlock?) {
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
}

extension DetailPresenter: DetailPresenterProtocol {
    var cellDataSource: [DetailCellType] {
        return cellsToDrow
    }
    
    func closeButtonTapped() {
        router.closeCurrentViewController()
    }
    
    func getMovieData() -> DetailModel? {
        return movieDataSource
    }
    
    func configureView() {
        fetchMovie(by: movieId) {
            self.view?.updateView()
        }
    }
}
