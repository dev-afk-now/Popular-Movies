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
        searchBar.searchTextField.textColor = .black
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
        title.font = UIFont(name: "Avenir",
                            size: 20)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.configureView()
        configureTableView()
        setupConstraints()
        setupNavigationBar()
        showActivityIndicator()
        layoutGradientView()
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
            titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.5),
            
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
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
    
    override func connectionDissapeared() {
        super.connectionDissapeared()
        // TODO: do presenter.configureViewOfflineMode
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
