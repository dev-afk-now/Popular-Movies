//
//  ViewController.swift
//  Popular Movies
//
//  Created by devmac on 10.01.2022.
//

import UIKit

protocol FeedViewProtocol: AnyObject {
    
}

class FeedViewController: UIViewController {
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
        presenter.configureView()
    }
    
    
}

extension FeedViewController: FeedViewProtocol {
    
}

extension FeedViewController: UITableViewDelegate {
    
}

