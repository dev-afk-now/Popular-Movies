//
//  PosterViewController.swift
//  Popular Movies
//
//  Created by devmac on 21.01.2022.
//

import UIKit

protocol PosterViewProtocol: AnyObject {
    func updateImageView(imageData: Data)
}

class PosterViewController: UIViewController {
    
    // MARK: - Public properties -
    var presenter: PosterPresenterProtocol!
    
    // MARK: - Private properties -
    private var imageAspectRatio: CGFloat = 1
    
    private lazy var backBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(title: "Close",
                                     style: .done,
                                     target: self,
                                     action: #selector(backBarButtonTapped))
        button.tintColor = .systemBlue
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(didDoubleTapView))
        tapGestureRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self,
                                                              action: #selector(didSwipe))
        swipeGestureRecognizer.direction = .down
        scrollView.addGestureRecognizer(swipeGestureRecognizer)
        return scrollView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupNavigationBar()
    }
    
    // MARK: - Private methods -
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = backBarButton
    }
    
    private func setupSubview() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            posterImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / imageAspectRatio),
        ])
    }
    
    private func setViewZoomScale(_ scaleValue: CGFloat) {
        scrollView.setZoomScale(scaleValue, animated: true)
    }
    
    // MARK: - Actions -
    @objc private func backBarButtonTapped() {
        presenter.closeView()
    }
    
    @objc private func didDoubleTapView(_ sender: UITapGestureRecognizer) {
        setViewZoomScale(scrollView.zoomScale > 1 ? 1 : 2)
    }
    
    @objc private func didSwipe() {
        presenter.closeView()
    }
}

// MARK: - Extensions -
extension PosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        posterImageView
    }
}

extension PosterViewController: PosterViewProtocol {
    func updateImageView(imageData: Data) {
        let image = UIImage(data: imageData)
        imageAspectRatio = Double(image?.size.width ?? 1) /
        Double(image?.size.height ?? 1)
        posterImageView.image = image
    }
}
