//
//  MovieTableCell.swift
//  Popular Movies
//
//  Created by devmac on 12.01.2022.
//

import UIKit

final class MovieTableCell: BaseTableViewCell {
    
    // MARK: - Private -
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.75).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = nil
    }
    
    private lazy var posterImage: UIImageView = {
        var view = UIImageView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headlineLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .black.withAlphaComponent(0.25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Futura Medium", size: 22)
        label.textColor = .white
        label.textAlignment = .left
        label.viewDropShadow()
        return label
    }()
    
    private lazy var starImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "star.fill")
        image.tintColor = .white
        image.contentMode = .scaleToFill
        image.viewDropShadow()
        return image
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .black.withAlphaComponent(0.25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Futura Medium", size: 20)
        label.textAlignment = .left
        label.viewDropShadow()
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .black.withAlphaComponent(0.25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "Futura Medium", size: 18)
        label.textAlignment = .left
        label.viewDropShadow()
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
        let containerInset: CGFloat = 10
        let verticalInset: CGFloat = 16
        let horizontalInset: CGFloat = 12
        
        self.addSubview(containerView)
        containerView.addSubview(posterImage)
        containerView.addSubview(headlineLabel)
        containerView.addSubview(genresLabel)
        containerView.addSubview(ratingLabel)
        containerView.addSubview(starImage)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: containerInset),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -containerInset),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: containerInset),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -containerInset),
            
            posterImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            posterImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            headlineLabel.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor, constant: horizontalInset),
            headlineLabel.trailingAnchor.constraint(lessThanOrEqualTo: posterImage.trailingAnchor, constant: -horizontalInset),
            headlineLabel.topAnchor.constraint(equalTo: posterImage.topAnchor, constant: verticalInset),
            
            starImage.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            starImage.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor, constant: horizontalInset),
            starImage.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            
            ratingLabel.topAnchor.constraint(greaterThanOrEqualTo: headlineLabel.bottomAnchor, constant: verticalInset),
            ratingLabel.bottomAnchor.constraint(equalTo: genresLabel.topAnchor,
                                                constant: -verticalInset),
            
            genresLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: verticalInset),
            genresLabel.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor, constant: horizontalInset),
            genresLabel.trailingAnchor.constraint(lessThanOrEqualTo: posterImage.trailingAnchor, constant: -horizontalInset),
            genresLabel.bottomAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: -verticalInset),
        ])
    }
    
    // MARK: - Internal -
    func configure(with movie: MovieCellItem) {
        headlineLabel.text = movie.title + ", " + movie.dateOfReleaseString
        ratingLabel.text = String(movie.rating)
        genresLabel.text = movie.genreArrayString.joined(separator: ", ")
        guard let poster = movie.imageURL else {
            return
        }
        posterImage.setImage(urlString: poster)
    }
}
