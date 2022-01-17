//
//  ViewController.swift
//  Popular Movies
//
//  Created by devmac on 10.01.2022.
//

import UIKit

protocol FeedViewProtocol: AnyObject {
    func updateView()
    func showError()
}

class FeedViewController: BaseViewController {
    var presenter: FeedPresenterProtocol!
    
    private var isLoading = false
    
    // MARK: - Private properties -
    
    private lazy var searchBarView: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        var button = UIBarButtonItem(image: UIImage(systemName: "text.append"),
                                     style: .done,
                                     target: self,
                                     action: #selector(sortButtonTapped))
        button.tintColor = .black
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont(name: "Avenir", size: 20)
        title.text = "Popular Movies"
        return title
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        MovieTableCell.register(in: tableView)
        TableLoadingCell.register(in: tableView)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.configureView()
        configureTableView()
        setupConstraints()
        setupNavigationBar()
        showActivityIndicator()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let appearance = UINavigationBarAppearance()
          appearance.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = sortButton
        navigationItem.titleView = titleLabel
    }
    
    private func configureTableView() {
        tableView.keyboardDismissMode = .interactive
    }
    
    private func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(searchBarView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func sortButtonTapped() {
        showActionSheet(title: "Sort",
                        with: presenter.sortOptionsString,
                        selected: presenter.selectedSortOptionIndex) {
            [weak self] actionTitle in
            print(actionTitle)
            self?.presenter.sortMovies(with: actionTitle)
        }
    }
}

extension FeedViewController: FeedViewProtocol {
    func showError() {
        hideActivityIndicator()
    }
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.hideActivityIndicator()
            self?.tableView.reloadData()
        }
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        //
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
        return 300
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.movieListCount - 3 {
            presenter.loadMoreData()
            showActivityIndicator()
        }
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        presenter.search(text: searchText)
    }
}
