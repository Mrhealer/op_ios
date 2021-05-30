//
//  JSONDecoder.swift

import Foundation

public struct JSONCustomDecoder {
    
    public static var decoder: JSONDecoder {
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .iso8601
        // phụ thuộc vào server trả về mà custome hay ko
        decoder.keyDecodingStrategy = .convertFromUpperCamelCase
        
        return decoder
    }
    
    public static var encoder: JSONEncoder {
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

extension JSONDecoder.KeyDecodingStrategy {
    
    static var convertFromUpperCamelCase: JSONDecoder.KeyDecodingStrategy {
        return .custom { codingKeys in
            guard let lastCodingKey = codingKeys.last else {
                return AnyCodingKey(stringValue: "")
            }
            var key = AnyCodingKey(lastCodingKey)
            
            // lowercase first letter
            if let firstChar = key.stringValue.first {
                let index = key.stringValue.startIndex
                key.stringValue.replaceSubrange(
                    index ... index, with: String(firstChar).lowercased()
                )
            }
            return key
        }
    }
}
