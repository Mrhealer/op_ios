//
//  Datale.swift

import Foundation

public protocol Datable {
    var asData: Data { get }
}

extension Bool: Datable {
    public var asData: Data {
        var valueInInt = Int(truncating: NSNumber(value: self)) //Convert Bool to Int
        let data = Data(bytes: &valueInInt, count: MemoryLayout.size(ofValue: valueInInt))
        return data
    }
}

extension URL: Datable {
    public var asData: Data {
        do {
            let data = try Data(contentsOf: self)
            return data
        } catch {
            return Data()
        }
    }
}

extension String: Datable {
    public var asData: Data {
        return self.data(using: .utf8) ?? Data()
    }
}

extension Int: Datable {
    public var asData: Data {
        var valueInInt = self
        let data = Data(bytes: &valueInInt, count: MemoryLayout.size(ofValue: valueInInt))
        return data
    }
}

extension Int64: Datable {
    public var asData: Data {
        var valueInInt = self
        let data = Data(bytes: &valueInInt, count: MemoryLayout.size(ofValue: valueInInt))
        return data
    }
}
