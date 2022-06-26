//
//  HeadlineTableCell.swift
//  Popular Movies
//
//  Created by devmac on 19.01.2022.
//

import UIKit

class HeadlineTableCell: BaseTableViewCell {
    
    // MARK: - Private properties -
    private lazy var headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .applicatonFont(.avenirHeavy, size: 25)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var secondaryInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .applicatonFont(.avenirHeavy, size: 22)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .applicatonFont(.avenirMedium, size: 22)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var taglineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .applicatonFont(.avenirHeavyOblique, size: 22)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .lightGray.withAlphaComponent(0.25)
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - Init -
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods -
    func configure(with movieData: DetailModel) {
        headlineLabel.text = movieData.title
        secondaryInfoLabel.text = (movieData.productionCountries.map{$0.name}
        ).joined(separator: ", ") + ", " +
        (movieData.yearOfReleaseString)
        genresLabel.text = movieData.genres.map{$0.name}.joined(separator: ", ")
        taglineLabel.text = String(format: "'%@'", movieData.tagline ?? "")
    }
    
    // MARK: - Private methods -
    private func setupSubviews() {
        let verticalInset: CGFloat = 16
        let horizontalInset: CGFloat = 12
        
        self.backgroundColor = .white
        self.addSubview(headlineLabel)
        self.addSubview(secondaryInfoLabel)
        self.addSubview(genresLabel)
        self.addSubview(taglineLabel)
        
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                   constant: horizontalInset),
            headlineLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                    constant: -horizontalInset),
            headlineLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                               constant: verticalInset),
            
            secondaryInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                        constant: horizontalInset),
            secondaryInfoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                         constant: -horizontalInset),
            secondaryInfoLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor),
            
            genresLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                 constant: horizontalInset),
            genresLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: -horizontalInset),
            genresLabel.topAnchor.constraint(equalTo: secondaryInfoLabel.bottomAnchor),
            
            taglineLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                 constant: horizontalInset),
            taglineLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: -horizontalInset),
            taglineLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor,
                                              constant: verticalInset / 2),
            taglineLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                constant: -verticalInset / 2)
        ])
    }
}
