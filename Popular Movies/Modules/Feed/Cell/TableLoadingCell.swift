//
//  TableLoadingCell.swift
//  Popular Movies
//
//  Created by devmac on 13.01.2022.
//

import Foundation
import NVActivityIndicatorView

final class TableLoadingCell: BaseTableViewCell {
    private lazy var activityIndicatorView: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .purple)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    private func setupSubviews() {
        self.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 35),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
}
