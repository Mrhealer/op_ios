//
//  Environments.swift

import Foundation

public enum Environment {
    case production, stage, development
    
    var serverURL: String {
        switch self {
        case .production:  return "https://fingzi.xyz/api/"
        case .stage:       return "https://fingzi.xyz/api/"
        case .development: return "https://fingzi.xyz/api/"
        }
    }
    
    var description: String {
        switch self {
        case .production:   return "production"
        case .stage:        return "stage"
        case .development:  return "development"
        }
    }
}
