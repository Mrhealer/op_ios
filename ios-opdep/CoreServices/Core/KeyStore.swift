//
//  KeyStore.swift

import Foundation

// Dùng cho việc lưu token và set token trong header

public protocol KeyStore {
    var accessToken: String? { get }
    func setAccessToken(_ accessToken: String?)
    
    var userId: String? { get }
    func setUserId(_ userId: String?)
}
