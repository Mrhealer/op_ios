//
//  AnyCodingKey.swift

import Foundation
// wrapper to allow us to substitute our mapped string keys.
// Thanks to https://stackoverflow.com/a/44396824/1310835

struct AnyCodingKey: CodingKey {
    
    var stringValue: String
    var intValue: Int?
    
    init(_ base: CodingKey) {
        self.init(stringValue: base.stringValue, intValue: base.intValue)
    }
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
}
