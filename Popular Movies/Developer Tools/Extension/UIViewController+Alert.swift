//
//  UIViewController+Alert.swift
//  Popular Movies
//
//  Created by devmac on 12.01.2022.
//

import UIKit

typealias BlockWithString = (String) -> ()

extension UIViewController {
    func showAlert(with errorMessage: String) {
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(title: String,
                         with actionTitles: [String],
                         selected index: Int?,
                         completion: @escaping BlockWithString) {
        let optionMenu = UIAlertController(title: nil,
                                           message: title,
                                           preferredStyle: .actionSheet)
        for titleIndex in actionTitles.indices {
            let actionTitle = actionTitles[titleIndex]
            let alertAction = UIAlertAction(title: actionTitle,
                                            style: .default) { action in
                completion(action.title ?? "null")
            }
            if index == titleIndex {
                alertAction.setValue(true, forKey: "checked")
            }
            optionMenu.addAction(alertAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
}
