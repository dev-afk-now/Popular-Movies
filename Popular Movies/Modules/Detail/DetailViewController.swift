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
    
    private lazy var backBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backBarButtonTapped))
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
    
    private lazy var posterImage: UIImageView = {
        var view = UIImageView()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.sectionHeaderHeight = view.bounds.width * 1.2
        HeadlineTableCell.register(in: tableView)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        presenter.configureView()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                               for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let appearance = UINavigationBarAppearance()
          appearance.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.titleView = titleLabel
    }
    
    private func setupConstraints() {
        let imageHeight = view.bounds.width / 1.5
        view.addSubview(tableView)
        view.addSubview(posterImage)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: imageHeight),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func backBarButtonTapped() {
        presenter.closeButtonTapped()
    }
}

extension DetailViewController: DetailViewProtocol {
    func updateView() {
        guard let movieData = presenter.getMovieData() else {
            return
        }
        posterImage.setImage(urlString: movieData.posterPath ?? "")
        titleLabel.text = movieData.title
        tableView.reloadData()
    }
}

extension DetailViewController: UITableViewDelegate {
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = presenter.cellDataSource[indexPath.row]
        guard let movieModel = presenter.getMovieData() else {
            return UITableViewCell()
        }
        let cell = HeadlineTableCell.cell(in: tableView, for: indexPath)
        cell.configure(with: movieModel)
        return cell
//        switch cellType {
//        case .headlineCell:
//
//        default:
//            return UITableViewCell()
//        }
    }
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        return posterImage
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
