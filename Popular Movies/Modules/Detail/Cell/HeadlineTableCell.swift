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
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setupSubviews()
        self.backgroundColor = UIColor.green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movieData: DetailModel) {
        headlineLabel.text = movieData.title + "\n" + movieData.dateOfReleaseString
    }
    
    private func setupSubviews() {
        let verticalInset: CGFloat = 16
        let horizontalInset: CGFloat = 12
        
        self.addSubview(headlineLabel)
        
        NSLayoutConstraint.activate([
            
            headlineLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalInset),
            headlineLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -horizontalInset),
            headlineLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: verticalInset),
            headlineLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalInset)
        ])
    }
}
