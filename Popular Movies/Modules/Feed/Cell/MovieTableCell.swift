//
//  MovieTableCell.swift
//  Popular Movies
//
//  Created by devmac on 12.01.2022.
//

import UIKit

final class MovieTableCell: BaseTableViewCell {
    
    // MARK: - Private properties -
    private lazy var containerView: UIView = {
        var view = UIView(frame: CGRect(x: .zero,
                                        y: .zero,
                                        width: contentView.bounds.width * 1.2,
                                        height: 230))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.75
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds,
                                             cornerRadius: 10).cgPath
        return view
    }()
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .applicatonFont(.futuraMedium, size: 22)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var starImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "star.fill")
        image.tintColor = .white
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .applicatonFont(.futuraMedium, size: 20)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .applicatonFont(.futuraMedium, size: 18)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var topGradientView: UIView = {
        let view = UIView(frame: CGRect(x: .zero,
                                        y: .zero,
                                        width: 400,
                                        height: 150))
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
                          startPoint: CGPoint(x: 0, y: 1),
                          endPoint: CGPoint(x: 0, y: 0))
        return view
    }()
    
    private lazy var bottomGradientView: UIView = {
        let view = UIView(frame: CGRect(x: .zero,
                                        y: .zero,
                                        width: 400,
                                        height: 150))
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
    
    // MARK: - LifeCycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutGradientView()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = nil
    }
    
    // MARK: - Public methods -
    func configure(with movie: MovieCellItem) {
        headlineLabel.text = movie.title + ", " + movie.dateOfReleaseString
        ratingLabel.text = String(movie.rating)
        genresLabel.text = movie.genreArrayString.joined(separator: ", ")
        guard let poster = movie.imageURL else {
            return
        }
        posterImage.setImage(urlString: poster)
    }
    
    // MARK: - Private methods -
    private func layoutGradientView() {
        posterImage.addSubview(topGradientView)
        posterImage.addSubview(bottomGradientView)
        
        NSLayoutConstraint.activate([
            bottomGradientView.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: posterImage.trailingAnchor),
            bottomGradientView.bottomAnchor.constraint(equalTo: posterImage.bottomAnchor),
            bottomGradientView.heightAnchor.constraint(equalToConstant: 150),
            
            topGradientView.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor),
            topGradientView.trailingAnchor.constraint(equalTo: posterImage.trailingAnchor),
            topGradientView.topAnchor.constraint(equalTo: posterImage.topAnchor)
        ])
    }
    
    private func setupSubviews() {
        let containerInset: CGFloat = 10
        let verticalInset: CGFloat = 16
        let horizontalInset: CGFloat = 12
        
        self.backgroundColor = .white
        self.addSubview(containerView)
        containerView.addSubview(posterImage)
        containerView.addSubview(headlineLabel)
        containerView.addSubview(genresLabel)
        containerView.addSubview(ratingLabel)
        containerView.addSubview(starImage)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                   constant: containerInset),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                    constant: -containerInset),
            containerView.topAnchor.constraint(equalTo: self.topAnchor,
                                               constant: containerInset),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                  constant: -containerInset),
            
            posterImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            posterImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            headlineLabel.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor,
                                                   constant: horizontalInset),
            headlineLabel.trailingAnchor.constraint(lessThanOrEqualTo: posterImage.trailingAnchor,
                                                    constant: -horizontalInset),
            headlineLabel.topAnchor.constraint(equalTo: posterImage.topAnchor,
                                               constant: verticalInset),
            
            starImage.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            starImage.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor,
                                               constant: horizontalInset),
            starImage.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            
            ratingLabel.topAnchor.constraint(greaterThanOrEqualTo: headlineLabel.bottomAnchor,
                                             constant: verticalInset),
            ratingLabel.bottomAnchor.constraint(equalTo: genresLabel.topAnchor,
                                                constant: -verticalInset / 2),
            
            genresLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor,
                                             constant: verticalInset / 2),
            genresLabel.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor,
                                                 constant: horizontalInset),
            genresLabel.trailingAnchor.constraint(lessThanOrEqualTo: posterImage.trailingAnchor,
                                                  constant: -horizontalInset),
            genresLabel.bottomAnchor.constraint(equalTo: posterImage.bottomAnchor,
                                                constant: -verticalInset),
        ])
    }
}
