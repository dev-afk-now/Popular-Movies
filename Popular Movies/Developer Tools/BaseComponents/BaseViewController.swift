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
        activityIndicatorView = NVActivityIndicatorView(frame: .zero,
                                                        type: .lineScale,
                                                        color: .black.withAlphaComponent(0.5))
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.isHidden = true
        view.addSubview(activityIndicatorView)
    }
    
    private func layoutActivityIndicator() {
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 35),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 35),
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
    @objc private func connectionDissapeared() {
        showAlert(with: noConnectionMessage)
    }
}