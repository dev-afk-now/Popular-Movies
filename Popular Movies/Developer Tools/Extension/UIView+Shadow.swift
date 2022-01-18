//
//  UIView+Shadow.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import UIKit

extension UIView {
    func viewDropShadow() {
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
    }
}
