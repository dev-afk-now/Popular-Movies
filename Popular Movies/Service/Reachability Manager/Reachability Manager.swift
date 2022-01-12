//
//  Reachability Manager.swift
//  Popular Movies
//
//  Created by devmac on 12.01.2022.
//

import Foundation
import Reachability

final class ReachabilityManager {
    static let shared = ReachabilityManager()
    let lostConnectionNotificationName = NSNotification.Name("connectionDisappeared")
    
    private let reachability = try! Reachability()
    
    private init() {
        startNotifying()
    }
    
    private func startNotifying() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        try? reachability.startNotifier()
    }
    
    @objc private func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.connection == .unavailable {
            NotificationCenter.default.post(name: lostConnectionNotificationName,
                                            object: self)
        }
    }
}
