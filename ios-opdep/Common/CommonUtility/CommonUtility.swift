//
//  CommonUtility.swift
//  GoCheap
//
//  Created by Nguyễn Quang on 1/18/21.
//

import Foundation
import UIKit

enum ValidateError: LocalizedError {
    case emptyFullName
    case incorrectFullName
    
    case emptyPhone
    case incorrectPhone
    
    case emptyEmail
    case incorrectEmail
    
    case emptyAddress
    case emptyCity
    
    case emptyPassword
    case confirmPasswordIncorrect
    
    case emptyOtp
    case incorrectOtp
    
    var errorDescription: String? {
        switch self {
        case .emptyFullName: return "Họ Và Tên không đươc để trống"
        case .incorrectFullName: return "Họ Và Tên không đúng định dạng"
            
        case .emptyPhone: return "Số Điện Thoại không đươc để trống"
        case .incorrectPhone: return "Số Điện Thoại không đúng định dạng"
            
        case .emptyEmail: return "E-mail không đươc để trống"
        case .incorrectEmail: return "E-mail không đúng định dạng"
            
        case .emptyPassword: return "Mật Khẩu không đươc để trống"
        case .confirmPasswordIncorrect: return "Xác nhận mật khẩu không đúng"
            
        case .emptyAddress: return "Địa chỉ không đươc để trống"
        case .emptyCity: return "Thành phố không đươc để trống"
            
        case .emptyOtp: return "Mã xác nhận không đươc để trống"
        case .incorrectOtp: return "Mã xác nhận không đúng định dạng"

        }
    }
}

class CommonUtility: NSObject {
    // MARK: VALID
    //valid email
    static func isValidEmail(_ testStr: String?) -> ValidateError? {
        if testStr?.trim() == nil || testStr?.trim().count == 0 {
            return ValidateError.emptyEmail
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: testStr?.trim()) {
            return nil
        }
        return ValidateError.incorrectEmail
    }
    //valid password
    static func isValidPassword(_ testStr: String?) -> ValidateError? {
        if testStr?.trim() == nil || testStr?.trim().count == 0 {
            return ValidateError.emptyPassword
        }
        return nil
    }
    //valid full name
    static func isValidFullName(_ testStr: String?) -> ValidateError? {
        if testStr?.trim() == nil || testStr?.trim().count == 0 {
            return ValidateError.emptyFullName
        }
        return nil
    }
    //valid number phone
    static func isValidPhone(_ testStr: String?) -> ValidateError? {
        if testStr?.trim() == nil || testStr?.trim().count == 0 {
            return ValidateError.emptyPhone
        }
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if phoneTest.evaluate(with: testStr?.trim()) {
            return nil
        }
        return ValidateError.incorrectPhone
    }
    //valid empty
    static func isValidEmpty(_ testStr: String?, error: ValidateError) -> ValidateError? {
        if testStr?.trim() == nil || testStr?.trim().count == 0 {
            return error
        }
        return nil
    }
    // MARK: END VALID
    
    // MARK: Convert array to string
    static func convertIntoJSONString(arrayObject: Any) -> String? {
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
    static func createPdfFromView(designLayer: CALayer?, desginBounds: CGRect?) -> Data {
        guard let layer = designLayer, let bounds = desginBounds else {
            return .init()
        }
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, bounds, nil)
        
        let rect = CGRect(origin: .zero,
                          size: UIScreen.main.bounds.size)
        
        UIGraphicsBeginPDFPageWithInfo(rect, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else {
            return .init()
        }
        layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return pdfData as Data
    }
}
