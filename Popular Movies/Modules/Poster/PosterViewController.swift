//
//  PosterViewController.swift
//  Popular Movies
//
//  Created by devmac on 21.01.2022.
//

import UIKit

protocol PosterViewProtocol: AnyObject {
    func updateView()
}

class PosterViewController: UIViewController {
    var presenter: PosterPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PosterViewController: PosterViewProtocol {
    func updateView() {
        //
    }
}
