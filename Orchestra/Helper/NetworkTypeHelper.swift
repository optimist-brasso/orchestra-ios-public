//
//  NetworkTypeHelper.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/08/2022.
//

import Foundation
import SystemConfiguration

class NetworkTypeHelper {
    
    static var networkType: String? {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return nil
        }
        // Only Working for WIFI
        var isReachable = flags == .reachable
        var needsConnection = flags == .connectionRequired
        let wifiReachable = isReachable && !needsConnection
        if wifiReachable {
            return "WIFI"
        }
        // Working for Cellular and WIFI
        isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let cellularReachable = (isReachable && !needsConnection)
        if cellularReachable {
            return "Cellular"
        }
        return nil
    }
    
}

import Combine
//import Alamofire

//enum NetworkStatus { case connected, notconnected }
enum NetworkType { case wifi, cellular }

final class NetworkReachability {
    
    // shared instance
    static let shared = NetworkReachability()
    private init() { startObserver() }
    
    // the status of network reachability
    let status = PassthroughSubject<Reachability.Connection, Never>()
    
    // the reachability manager from Reachability
    private var reachabilityManager: Reachability?
    
    // start observing
    private func startObserver() {
        do {
            reachabilityManager = try Reachability(hostname: "www.google.com")
            reachabilityManager?.whenReachable = { [weak self] reachability in
                self?.status.send(reachability.connection)
//                self.status.send(.connected)
            }
            reachabilityManager?.whenUnreachable = { reachability in
                self.status.send(.unavailable)
//                self.status.send(.notconnected)
            }
            try reachabilityManager?.startNotifier()
        } catch {
//            log(error.localizedDescription)
        }
    }

    var networkType: Reachability.Connection? {
        return reachabilityManager?.connection
    }
    
}
