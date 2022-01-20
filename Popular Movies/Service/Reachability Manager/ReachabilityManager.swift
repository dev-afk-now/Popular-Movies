//
//  ReachabilityManager.swift
//  Popular Movies
//
//  Created by devmac on 12.01.2022.
//

import Foundation
import Reachability

extension Notification.Name {
    static var connectionLost: Notification.Name {
        return .init("connectionDisappeared")
    }

    static var connectionReastablished: Notification.Name {
        return .init("connectionReastablished")
    }

}

final class ReachabilityManager {
    static let shared = ReachabilityManager()
    
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
        
        switch reachability.connection {
        case .cellular, .wifi:
            NotificationCenter.default.post(name: .connectionReastablished,
                                            object: self)
        case .unavailable:
            NotificationCenter.default.post(name: .connectionLost,
                                            object: self)
        default: break
        }
        
    }
}
