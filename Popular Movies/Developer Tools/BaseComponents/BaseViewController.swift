//
//  BaseViewController.swift
//  Popular Movies
//
//  Created by devmac on 12.01.2022.
//

import UIKit
import Reachability
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    
    // MARK: - Private properties -
    private let noConnectionMessage = "You are offline. Please, enable your Wi-Fi or connect - using cellular data."
    private var activityIndicatorView: NVActivityIndicatorView!
    
    // MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        layoutActivityIndicator()
        startRecieveConnectionNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .connectionLost,
                                                  object: ReachabilityManager.shared)
        NotificationCenter.default.removeObserver(self,
                                                  name: .connectionReastablished,
                                                  object: ReachabilityManager.shared)
    }
    
    // MARK: - Private methods -
    private func startRecieveConnectionNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(connectionDisappeared),
                                               name: .connectionLost,
                                               object: ReachabilityManager.shared)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(connectionAppeared),
                                               name: .connectionReastablished,
                                               object: ReachabilityManager.shared)
    }
    
    private func configureActivityIndicator() {
        let indicatorColor: UIColor = .gray
        activityIndicatorView = NVActivityIndicatorView(frame: .zero,
                                                        type: .circleStrokeSpin,
                                                        color: indicatorColor)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.isHidden = true
        view.addSubview(activityIndicatorView)
    }
    
    private func layoutActivityIndicator() {
        let indicatorSide: CGFloat = 55
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: indicatorSide),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: indicatorSide),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showActivityIndicator() {
        view.bringSubviewToFront(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
    
    // MARK: - Actions -
    @objc func connectionDisappeared() {
        showAlert(with: noConnectionMessage)
    }
    
    @objc func connectionAppeared() {}
}
