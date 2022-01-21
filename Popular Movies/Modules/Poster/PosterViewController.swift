//
//  PosterViewController.swift
//  Popular Movies
//
//  Created by devmac on 21.01.2022.
//

import UIKit

protocol PosterViewProtocol: AnyObject {
    
}

class PosterViewController: UIViewController {
    var presenter: PosterPresenterProtocol
}

extension PosterViewController: PosterViewProtocol {
    
}
