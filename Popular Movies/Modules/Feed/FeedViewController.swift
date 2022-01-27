//
//  ViewController.swift
//  Popular Movies
//
//  Created by devmac on 10.01.2022.
//

import UIKit

protocol FeedViewProtocol: AnyObject {
    func updateView()
    func showNoResultsIfNeeded(_ isNeeded: Bool)
    func showLoading()
    func hideLoading()
}

class FeedViewController: BaseViewController {
    
    // MARK: - Public properties -
    var presenter: FeedPresenterProtocol!
    
    
    // MARK: - Private properties -
    private lazy var searchBarView: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: view.bounds.width,
                                                  height: 60))
        searchBar.backgroundColor = .white
        searchBar.tintColor = .black
        searchBar.searchTextField.textColor = .black
        searchBar.delegate = self
        searchBar.setImage(UIImage(),
                           for: .search,
                           state: .normal)
        searchBar.placeholder = "Search"
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "text.append"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(sortButtonTapped))
        button.tintColor = .black
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = .applicatonFont(.avenirMedium, size: 18)
        title.text = "Popular Movies"
        title.textAlignment = .center
        return title
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = searchBarView
        tableView.keyboardDismissMode = .interactive
        MovieTableCell.register(in: tableView)
        return tableView
    }()
    
    private lazy var bottomGradientView: UIView = {
        let view = UIView(frame: CGRect(x: .zero,
                                        y: .zero,
                                        width: view.bounds.width,
                                        height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.makeGradient(colors: [UIColor.clear,
                                   UIColor.black.withAlphaComponent(0.016),
                                   UIColor.black.withAlphaComponent(0.03125),
                                   UIColor.black.withAlphaComponent(0.0625),
                                   UIColor.black.withAlphaComponent(0.125),
                                   UIColor.black.withAlphaComponent(0.25),
                                   UIColor.black.withAlphaComponent(0.45)
                                  ],
                          startPoint: CGPoint(x: 0, y: 0),
                          endPoint: CGPoint(x: 0, y: 1))
        return view
    }()
    
    // MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setContent()
        setupConstraints()
        setupNavigationBar()
        layoutGradientView()
    }
    
    // MARK: - Private methods -
    private func setupNavigationBar() {
        navigationItem.titleView = titleLabel
    }
    
    private func setupConstraints() {
        let titleWidth = view.bounds.width / 1.5
        view.addSubview(titleLabel)
        view.addSubview(searchBarView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: titleWidth),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func layoutGradientView() {
        view.addSubview(bottomGradientView)
        
        NSLayoutConstraint.activate([
            bottomGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomGradientView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setEmptyStateIfNeeded(_ itemsIsEmpty: Bool) {
        let noResultsImage = UIImage(named: "noResults")
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = itemsIsEmpty ? noResultsImage : nil
        tableView.backgroundView = imageView
    }
    
    private func setupNavigationBarSortButton(_ isVisible: Bool) {
        navigationItem.setRightBarButton(isVisible ? sortButton : nil,
                                         animated: true)
    }
    
    func scrollToTop() {
        tableView.setContentOffset(.zero,
                                   animated: true)
    }
    
    override func connectionDisappeared() {
        super.connectionDisappeared()
        setupNavigationBarSortButton(false)
    }
    
    override func connectionAppeared() {
        super.connectionAppeared()
        setupNavigationBarSortButton(true)
    }
    
    // MARK: - Actions -
    @objc private func sortButtonTapped() {
        showActionSheet(title: "Sort",
                        with: presenter.sortOptionsString,
                        selected: presenter.selectedSortOptionIndex) {
            [weak self] actionTitle in
            self?.presenter.sortMovies(with: actionTitle)
        }
    }
}

// MARK: - Extensions -
extension FeedViewController: FeedViewProtocol {
    func showNoResultsIfNeeded(_ isNeeded: Bool) {
        setEmptyStateIfNeeded(isNeeded)
    }
    
    func showLoading() {
        showActivityIndicator()
    }
    
    func hideLoading() {
        hideActivityIndicator()
    }
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            if self?.presenter.movieListCount == 20 {
                self?.scrollToTop()
            }
        }
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        presenter.movieItemSelected(at: indexPath.row)
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return presenter.movieListCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellState = presenter.getMovieItemForCell(at: indexPath.row)
        let cell = MovieTableCell.cell(in: tableView, for: indexPath)
        cell.configure(with: cellState)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.movieListCount - 3 {
            presenter.loadMoreData()
        }
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        presenter.search(text: searchText)
    }
}
