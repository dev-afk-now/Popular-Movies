//
//  UIViewController+Alert.swift
//  Popular Movies
//
//  Created by devmac on 12.01.2022.
//

import UIKit

extension UIViewController {
    func showAlert(with errorMessage: String) {
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                               comment: "Default action"),
                                      style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
