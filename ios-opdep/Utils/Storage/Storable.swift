//
//  Storable.swift

import Foundation

protocol Storable: Codable {
    func encoded() -> Data?
    static func fromData(_ data: Data?) -> Self?
}

extension Storable {
    func encoded() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
    static func fromData(_ data: Data?) -> Self? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(Self.self, from: data)
    }
}

extension StorageService {
    func save<T: Storable>(_ value: T?, forKey key: Key) {
        save(value?.encoded(), forKey: key)
    }
    
    func value<T: Storable>(forKey key: Key) -> T? {
        T.fromData(data(forKey: key))
    }
}
