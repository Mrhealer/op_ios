//
//  AppSettings.swift

import Foundation

enum AppSettings {
    enum BuildType {
        case release
        case stage
        case debug
        static var current: BuildType = {
            #if STAGE_RELEASE
            return .stage
            #elseif DEV_RELEASE
            return .debug
            #else
            return .release
            #endif            
        }()
        
        var debugEnabled: Bool {
            #if DEBUG
            return true
            #else
            return self == .debug || self == .stage
            #endif
        }
    }

    static var environment: Environment {
        switch BuildType.current {
        case .release: return .production
        case .stage:   return .stage
        case .debug:   return .development
        }
    }
    
    static let isDebugging: Bool = BuildType.current.debugEnabled
}
