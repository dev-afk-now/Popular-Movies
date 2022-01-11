//
//  AppDelegate.swift
//  Popular Movies
//
//  Created by devmac on 10.01.2022.
//

import UIKit
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = FeedConfigurator.create()
        window?.makeKeyAndVisible()
        setupNetworkLogging()
        
        return true
    }
    
    private func setupNetworkLogging() {
        NFX.sharedInstance().start()
    }
}

