//
//  BaseViewController.swift
//  Popular Movies
//
//  Created by devmac on 12.01.2022.
//

import UIKit
import Reachability

class BaseViewController: UIViewController {
    
    // MARK: - Private properties -
    private let noConnectionMessage = "You are offline. Please, enable your Wi-Fi or connect - using cellular data."
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - LifeCycle -
    init() {
        super.init(nibName: nil, bundle: nil)
        startRecieveConnectionNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        startRecieveConnectionNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        layoutActivityIndicator()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityManager.shared.lostConnectionNotificationName,
                                                  object: ReachabilityManager.shared)
    }
    
    // MARK: - Private methods -
    private func startRecieveConnectionNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(connectionDissapeared),
                                               name: ReachabilityManager.shared.lostConnectionNotificationName,
                                               object: ReachabilityManager.shared)
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }
    
    private func layoutActivityIndicator() {
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Actions -
    @objc private func connectionDissapeared() {
        showAlert(with: noConnectionMessage)
    }
}
