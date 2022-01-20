//
//  DescriptionTableCell.swift
//  Popular Movies
//
//  Created by Никита Дубовик on 19.01.2022.
//

import UIKit

class DescriptionTableCell: BaseTableViewCell {
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.75).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir", size: 22)
        label.textColor = .black
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
        descriptionLabel.text = "Overview:\n" + movieData.overview
    }
    
    private func setupSubviews() {
        let verticalInset: CGFloat = 16
        let horizontalInset: CGFloat = 12
        self.backgroundColor = .white
        self.addSubview(containerView)
        self.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor,
                                                  constant: verticalInset),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                  constant: -verticalInset),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                      constant: horizontalInset),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor,
                                                    constant: -horizontalInset),
            descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                  constant: verticalInset),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                  constant: -verticalInset)
        ])
    }
}
