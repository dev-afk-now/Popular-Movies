//
//  UIImageView+ImageManager.swift
//  Popular Movies
//
//  Created by devmac on 17.01.2022.
//

import UIKit

extension UIImageView {
    func setImage(urlString: String) {
        ImageManager.shared.setImage(urlString, for: self)
    }
}
