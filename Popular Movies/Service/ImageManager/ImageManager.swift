//
//  ImageManager.swift
//  Popular Movies
//
//  Created by devmac on 17.01.2022.
//

import Foundation
import Kingfisher

final class ImageManager {
    static let shared = ImageManager()
    
    private init() {}
    
    func setImage(_ urlString: String, for imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            return
        }
        imageView.kf.setImage(with: url)
    }
}
