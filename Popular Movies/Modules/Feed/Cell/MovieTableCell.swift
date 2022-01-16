//
//  MovieTableCell.swift
//  Popular Movies
//
//  Created by devmac on 12.01.2022.
//

import UIKit

final class MovieTableCell: BaseTableViewCell {
    
    // MARK: - Private -
    private lazy var aspectRatio = (imageContainer.image?.size.width)! / (imageContainer.image?.size.height)!
    
    private lazy var imageContainer: UIImageView = {
        var view = UIImageView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headlineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black.withAlphaComponent(0.25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black.withAlphaComponent(0.25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black.withAlphaComponent(0.25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Action, Drama, Buddy Movie, Musical"
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.addSubview(imageContainer)
        imageContainer.addSubview(headlineLabel)
        imageContainer.addSubview(genresLabel)
        imageContainer.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            imageContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageContainer.topAnchor.constraint(equalTo: self.topAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            
            headlineLabel.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 12),
            headlineLabel.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 16),
            headlineLabel.heightAnchor.constraint(equalToConstant: 30),
            
            ratingLabel.topAnchor.constraint(greaterThanOrEqualTo: headlineLabel.bottomAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 12),
            
            genresLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16),
            genresLabel.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 12),
            genresLabel.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -16),            
        ])
        headlineLabel.font = UIFont(name: "Futura Medium", size: 20)
        genresLabel.font = UIFont(name: "Futura Medium", size: 18)
        ratingLabel.font = UIFont(name: "Futura Medium", size: 18)
    }
    
    // MARK: - Internal -
    func configure(with movie: MovieCellItem) {
        headlineLabel.text = movie.title
        ratingLabel.text = String(movie.rating)
        guard let pathString = movie.imageURL else {
            return
        }
        let data = try? Data(contentsOf: pathString)
        guard let data = data else { return }
        imageContainer.image = UIImage(data: data)
    }
}
