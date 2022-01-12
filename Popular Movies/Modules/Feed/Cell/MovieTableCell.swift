//
//  MovieTableCell.swift
//  Popular Movies
//
//  Created by devmac on 12.01.2022.
//

import UIKit

final class MovieTableCell: BaseTableViewCell {
    
    // MARK: - Private -
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupSubviews() {
        
    }
    
    // MARK: - Internal -
    func configure(with movie: MovieCellItem) {
        titleLabel.text = movie.title
    }
}
