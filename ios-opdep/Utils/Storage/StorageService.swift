//
//  StorageService.swift

import Foundation

protocol Storage {
    func set(_ value: Any?, forKey key: String)
    func object(forKey key: String) -> Any?
    func removeObject(forKey key: String)
}

protocol StorageKey: CaseIterable, RawRepresentable {
    var rawValue: String { get }
}

protocol StorageService {
    associatedtype Key: StorageKey
    var storage: Storage { get }
    func save<T>(_ value: T?, forKey key: Key)
    func value<T>(forKey key: Key) -> T?
}

extension StorageService {
    // MARK: - Set
    func save<T>(_ value: T?, forKey key: Key) {
        storage.set(value, forKey: key.rawValue)
    }

    func save<T: RawRepresentable>(_ value: T?, forKey key: Key) {
        save(value?.rawValue, forKey: key)
    }
    
    func save<T: NSCoding>(_ value: T?, forKey key: Key) {
        guard let value = value else {
            remove(forKey: key)
            return
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        save(data, forKey: key)
    }

    // MARK: - Get
    func value<T>(forKey key: Key) -> T? {
        storage.object(forKey: key.rawValue) as? T
    }

    func value<T: RawRepresentable>(forKey key: Key) -> T? {
        guard let value = storage.object(forKey: key.rawValue) as? T.RawValue else { return nil }
        return T(rawValue: value)
    }
    
    func value<T: NSCoding>(forKey key: Key) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
    }
    
    // MARK: - Removal
    func remove(forKey key: Key) {
        storage.removeObject(forKey: key.rawValue)
    }
}

// MARK: - Helpers
extension StorageService {
    func string(forKey key: Key) -> String? {
        value(forKey: key)
    }
    
    func bool(forKey key: Key) -> Bool? {
        value(forKey: key)
    }
    
    func data(forKey key: Key) -> Data? {
        storage.object(forKey: key.rawValue) as? Data
    }
}
