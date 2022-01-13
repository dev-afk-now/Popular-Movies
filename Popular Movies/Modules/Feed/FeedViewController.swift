//
//  ViewController.swift
//  Popular Movies
//
//  Created by devmac on 10.01.2022.
//

import UIKit

protocol FeedViewProtocol: AnyObject {
    func updateView()
}

class FeedViewController: BaseViewController {
    var presenter: FeedPresenterProtocol!
    
    private var isLoading = false
    
    // MARK: - Private properties -
    
    private lazy var searchBarView: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        MovieTableCell.register(in: tableView)
        TableLoadingCell.register(in: tableView)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        presenter.configureView()
        configureTableView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showActivityIndicator()
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .red
        tableView.keyboardDismissMode = .interactive
    }
    private func setupConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension FeedViewController: FeedViewProtocol {
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
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return presenter.movieListCount
            } else if section == 1 {
                return 1
            } else {
                return 0
            }
        }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellState = presenter.getMovieItemForCell(at: indexPath.row)
            let cell = MovieTableCell.cell(in: tableView, for: indexPath)
            cell.configure(with: cellState)
            return cell
        } else {
            let cell = TableLoadingCell.cell(in: tableView, for: indexPath)
            cell.startAnimating()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 55
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) {
            presenter.paginateMovieList()
        }
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}

