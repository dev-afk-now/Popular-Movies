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
        title.font = .applicatonFont(.avenirMedium, size: 18)
        title.text = "Popular Movies"
        title.textAlignment = .center
        return title
    }()
    
    private lazy var posterImage: UIImageView = {
        var view = UIImageView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: view.bounds.width,
                                             height: view.bounds.width * 1.2))
        return view
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
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = posterImage
        HeadlineTableCell.register(in: tableView)
        DescriptionTableCell.register(in: tableView)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicator()
        setupNavigationBar()
        presenter.configureView()
        setupConstraints()
        layoutGradientView()
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
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: imageHeight),
            
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
    
    @objc private func backBarButtonTapped() {
        presenter.closeButtonTapped()
    }
}

extension DetailViewController: DetailViewProtocol {
    func updateView() {
        hideActivityIndicator()
        guard let movieData = presenter.getMovieData() else {
            return
        }
        posterImage.setImage(urlString: movieData.posterPath ?? "")
        tableView.tableHeaderView = posterImage
        titleLabel.text = movieData.title
        tableView.reloadData()
    }
}

extension DetailViewController: UITableViewDelegate { }

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        presenter.cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = presenter.cellDataSource[indexPath.row]
        guard let movieModel = presenter.getMovieData() else {
            return UITableViewCell()
        }
        switch cellType {
        case .headlineCell:
            let cell = HeadlineTableCell.cell(in: tableView,
                                              for: indexPath)
            cell.configure(with: movieModel)
            return cell
        case .descriptionCell:
            let cell = DescriptionTableCell.cell(in: tableView,
                                              for: indexPath)
            cell.configure(with: movieModel)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
