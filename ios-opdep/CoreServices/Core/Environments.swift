//
//  Environments.swift

import Foundation

public enum Environment {
    case production, stage, development
    
    var serverURL: String {
        switch self {
        case .production:  return "https://opdep.opdienthoaidep.vn/api/"
        case .stage:       return "https://opdep.opdienthoaidep.vn/api/"
        case .development: return "https://opdep.opdienthoaidep.vn/api/"
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
