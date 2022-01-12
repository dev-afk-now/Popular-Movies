//
//  ViewController.swift
//  Popular Movies
//
//  Created by devmac on 10.01.2022.
//

import UIKit

protocol FeedViewProtocol: AnyObject {
    func updateView()
    func showError(_ message: String)
}

class FeedViewController: BaseViewController {
    var presenter: FeedPresenterProtocol!
    
    // MARK: - Private properties -
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        MovieTableCell.register(in: tableView)
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
    func showError(_ message: String) {
        self.showAlert(with: message)
    }
    
    func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        presenter.movieListCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MovieTableCell.cell(in: tableView, for: indexPath)
        let cellState = presenter.getMovieItemForCell(at: indexPath.row)
        cell.configure(with: cellState)
        return cell
    }
}

