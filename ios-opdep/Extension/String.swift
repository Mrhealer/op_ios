//
//  String.swift
//  GoCheap
//
//  Created by Nguyễn Quang on 1/18/21.
//

import Foundation
import UIKit

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return boundingBox.height
    }
    
    func heightWithConstrainedWidth(width: CGFloat,
                                    font: UIFont,
                                    attributes: [NSAttributedString.Key: Any]?) -> CGFloat {
        let constraintRect = CGSize(width: width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: attributes,
                                            context: nil)
        return boundingBox.height
    }
    
    func escape() -> String {
        let allowedCharacters = self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        return allowedCharacters
    }
    
    //Converts String to Int
    public func toInt() -> Int {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return 0
        }
    }
    
    func sizeOfText(_ font: UIFont) -> CGSize {
        return self.size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}

extension Int {
    //Converts Int to String
    public func toString() -> String {
        return "\(self)"
    }
}

extension Optional {
    func asStringOrEmpty() -> String {
        switch self {
            case .some(let value):
                return String(describing: value)
            case _:
                return ""
        }
    }

    func asStringOrNilText() -> String {
        switch self {
            case .some(let value):
                return String(describing: value)
            case _:
                return "(nil)"
        }
    }
    
    func asIntOrEmpty() -> String {
        switch self {
            case .some(let value):
                return String(describing: value)
            case _:
                return "0"
        }
    }
}
