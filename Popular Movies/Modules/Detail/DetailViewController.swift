//
//  DetailViewController.swift
//  Popular Movies
//
//  Created by devmac on 18.01.2022.
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    func updateView()
}

class DetailViewController: BaseViewController {
    var presenter: DetailPresenterProtocol!
    
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        print("detail loaded")
        view.backgroundColor = .red
    }
}

extension DetailViewController: DetailViewProtocol {
    func updateView() {
        //
    }
}

