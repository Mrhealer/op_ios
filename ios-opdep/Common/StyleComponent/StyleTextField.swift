//
//  StyleTextField.swift

import Foundation
import UIKit

class StyleTextField: UITextField {
    init(placeHolder: String? = nil, returnKeyType: UIReturnKeyType = .done, isSecure: Bool = false) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.returnKeyType = returnKeyType
        self.isSecureTextEntry = isSecure
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
