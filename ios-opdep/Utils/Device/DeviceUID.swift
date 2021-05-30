//
//  DeviceUID.swift

import Foundation
import UIKit

// Maybe change with storage
class DeviceUID {
    private let storeKey = "deviceUID"
    static let shared = DeviceUID()
    // Keychain
    private func valueForKeychain(key: String, service: String) -> String? {
        let getQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccessible as String: kSecAttrAccessibleAlways,
        kSecAttrAccount as String: key,
        kSecAttrService as String: service,
        kSecReturnData as String: true,
        kSecReturnAttributes as String: true]
        var result: AnyObject?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }
        guard let queriedItem = result as? [String: Any], let data = queriedItem[kSecValueData as String] as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    private func setKeychain(value: String, key: String, service: String) {
        guard let data =  value.data(using: .utf8) else {
            return
        }
        let addQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccessible as String: kSecAttrAccessibleAlways,
        kSecAttrAccount as String: key,
        kSecAttrService as String: service,
        kSecValueData as String: data]
        SecItemAdd(addQuery as CFDictionary, nil)
    }
    
    // Userdefault
    private func setUserDefault(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func valueForUserDefault(key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }
    
    // IFV
    private func appleIFV() -> String? {
        UIDevice.current.identifierForVendor?.uuidString
    }
    
    // Random UUID
    private func randomUUID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)
        let uuidSring: String = cfStr as String
        return uuidSring
    }
    
    private func save(uid: String) {
        if self.valueForUserDefault(key: storeKey) == nil {
            self.setUserDefault(value: uid, key: storeKey)
        }
        if self.valueForKeychain(key: storeKey, service: storeKey) == nil {
            self.setKeychain(value: uid, key: storeKey, service: storeKey)
        }
    }
    
    // Get and store
    func uid() -> String {
        var uid = ""
        if let uidFromKeychain = self.valueForKeychain(key: storeKey, service: storeKey) {
            uid = uidFromKeychain
        } else if let uidFromUserDefault = self.valueForUserDefault(key: storeKey) {
            uid = uidFromUserDefault
        } else if let uidFromIFV = self.appleIFV() {
            uid = uidFromIFV
        } else {
            uid = self.randomUUID()
        }
        save(uid: uid)
        return uid
    }
}
