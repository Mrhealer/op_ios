//
//  LocalStorage.swift

import Foundation

extension UserDefaults: Storage {}

struct LocalStorage: StorageService {
    enum Key: String, StorageKey {
        case sessionAccessToken = "loginResult.token.value"
        case userId = "loginResult.userId"
        case carts = "shoppingCart.carts"
    }
    
    let storage: Storage
    init(storage: Storage = UserDefaults.standard) {
        self.storage = storage
    }
    
    func clearAll() {
        Key.allCases.forEach {
            remove(forKey: $0)
        }
    }
}

extension LocalStorage: KeyStore {
    // access Token
    var accessToken: String? { string(forKey: .sessionAccessToken) }
    
    func setAccessToken(_ accessToken: String?) {
        save(accessToken, forKey: .sessionAccessToken)
    }
    
    var userId: String? { string(forKey: .userId) }
    
    func setUserId(_ userId: String?) {
        save(userId, forKey: .userId)
    }
    
    var carts: String? { string(forKey: .carts) }
    
    func setCarts(_ cart: [CartItemViewModel]?) {
        save(userId, forKey: .carts)
    }
}
