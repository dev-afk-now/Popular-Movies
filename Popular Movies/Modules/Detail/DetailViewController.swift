//
//  DetailViewController.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    func updateView()
}

class DetailViewController: BaseViewController {
    var presenter: DetailPresenterProtocol!
    
    private var isLoading = false
    
    // MARK: - Private properties -
    
//    private lazy var titleLabel: UILabel = {
//        let title = UILabel()
//        title.textColor = .black
//        title.font = UIFont(name: "Avenir",
//                            size: 20)
//        title.text = "Popular Movies"
//        return title
//    }()
    private lazy var sortButton: UIBarButtonItem = {
        var button = UIBarButtonItem(image: UIImage(systemName: "text.append"),
                                     style: .done,
                                     target: self,
                                     action: nil)
        button.tintColor = UIColor.black
        return button
    }()
    
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        MovieTableCell.register(in: tableView)
//        TableLoadingCell.register(in: tableView)
//        return tableView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.configureView()
        view.backgroundColor = .red
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
//        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
//        navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance()
//        navigationItem.leftBarButtonItem = sortButton
//        navigationItem.titleView = titleLabel
    }
    
    private func configureTableView() {
//        tableView.keyboardDismissMode = .interactive
    }
    
    private func setupConstraints() {
//        view.addSubview(titleLabel)
//        view.addSubview(searchBarView)
//        view.addSubview(tableView)
//
//        NSLayoutConstraint.activate([
//
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
    }
}

extension DetailViewController: DetailViewProtocol {
    func updateView() {
        //
    }
}

