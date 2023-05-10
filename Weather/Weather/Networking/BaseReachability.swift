//
//  BaseReachability.swift
//  Weather
//
//  Created by Islam Elgaafary on 11/05/2023.
//

import Foundation
import Alamofire

class BaseReachability {
    
    static let shared = BaseReachability()
    
    let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    
    func startNetworkMonitoring() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                self.showOfflineAlert()
            case .reachable(.cellular):
                self.dismissOfflineAlert()
            case .reachable(.ethernetOrWiFi):
                self.dismissOfflineAlert()
            case .unknown:
                print("Unknown network state")
            }
        }
    }
    
    func stopListening() {
        reachabilityManager?.stopListening()
    }
    
    private func showOfflineAlert() {
        // TODO
    }
    
    private func dismissOfflineAlert() {
        // TODO
    }
}
