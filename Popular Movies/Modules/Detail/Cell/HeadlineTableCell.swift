//
//  HeadlineTableCell.swift
//  Popular Movies
//
//  Created by devmac on 19.01.2022.
//

import UIKit

class HeadlineTableCell: BaseTableViewCell {

    private lazy var headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Futura Medium", size: 25)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Futura Medium", size: 22)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movieData: DetailModel) {
        headlineLabel.text = (movieData.title +
                              "\n") +
                              (movieData.productionCountries.map{$0.name}
                              ).joined(separator: ", ") + ", " +
                              (movieData.dateOfReleaseString)
        genresLabel.text = movieData.genres.map{$0.name}.joined(separator: ", ")
                              
    }
    
    private func setupSubviews() {
        let verticalInset: CGFloat = 16
        let horizontalInset: CGFloat = 12
        
        self.addSubview(headlineLabel)
        self.addSubview(genresLabel)
        
        NSLayoutConstraint.activate([
            
            headlineLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalInset),
            headlineLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -horizontalInset),
            headlineLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: verticalInset),
            
            genresLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalInset),
            genresLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -horizontalInset),
            genresLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor),
            genresLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalInset)
        ])
    }
}
