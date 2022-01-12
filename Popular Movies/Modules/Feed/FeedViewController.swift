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
        tableView.backgroundColor = .red
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        presenter.configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showActivityIndicator()
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .lightGray
        tableView.keyboardDismissMode = .interactive
    }
    private func setupConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.bottomAnchor),
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
    
}

