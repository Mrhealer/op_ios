//
//  NetworkStatus.swift

import Foundation
import Alamofire
import CoreTelephony

enum NetworkStatusType: Int {
    case none = 0
    case low = 1     // 2G
    case medium = 2  // 3G
    case high = 3    // 4G .. more
    case wiFi = 4    // wifi
    case unknown = 5
}

class NetworkStatus {
    
    static let shared = NetworkStatus()
    private init() {}
    private var type: NetworkStatusType = .none
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(onQueue: .global(qos: .background)) { [weak self] status in
            switch status {
            case .notReachable:
                self?.type = .none
            case .unknown :
                self?.type = .unknown
            case .reachable(.ethernetOrWiFi):
                self?.type = .wiFi
            case .reachable(.cellular):
                let telInfo = CTTelephonyNetworkInfo()
                if telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyGPRS
                    || telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyEdge
                    || telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyCDMA1x {
                    self?.type = .low
                } else if telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyWCDMA
                    || telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyHSDPA
                    || telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyHSUPA
                    || telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyCDMAEVDORev0
                    || telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyCDMAEVDORevA
                    || telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyCDMAEVDORevB
                    || telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyeHRPD {
                    self?.type = .medium
                } else if telInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyLTE {
                    self?.type = .high
                } else {
                    self?.type = .high
                }
            }
        }
    }
    
    func networkType() -> String {
        var name = ""
        switch type {
        case .wiFi:
            name = "Wifi"
        case .high:
            name = "4G"
        case .medium:
            name = "3G"
        case .low:
            name = "2G"
        case .unknown:
            name = "Unknow"
        default:
            name = ""
        }
        return name
    }
}
