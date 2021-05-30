//
//  SkyFloatingLabelTextField.swift

import SkyFloatingLabelTextField

extension SkyFloatingLabelTextField {
    @discardableResult
    func apply(_ title: String? = nil,
               placeholder: String? = nil,
               titleFont: UIFont = UIFont.primary(),
               placeholderFont: UIFont = UIFont.font(style: .italic, size: 20),
               titleColor: UIColor? = UIColor.Basic.black,
               placeholderColor: UIColor = UIColor.Basic.black,
               lineColor: UIColor = UIColor.Basic.black,
               selectedLineColor: UIColor = UIColor.Basic.black,
               isSecureTextEntry: Bool = false) -> Self {
        self.title = title
        self.placeholder = placeholder ?? title
        self.textColor = titleColor
        self.titleColor = titleColor ?? UIColor.Basic.black
        self.placeholderColor = placeholderColor
        self.font = titleFont
        self.placeholderFont = placeholderFont
        self.selectedTitleColor = .init(hexString: "f57224")
        self.lineColor = lineColor
        self.selectedLineColor = selectedLineColor
        self.isSecureTextEntry = isSecureTextEntry
        self.titleFormatter = { (text: String) -> String in return text }
        return self
    }
    
    class func create(_ title: String? = nil,
                      placeholder: String? = nil,
                      titleFont: UIFont = .font(style: .regular, size: 14),
                      placeholderFont: UIFont = .font(style: .regular, size: 14),
                      titleColor: UIColor? = UIColor.Basic.black,
                      placeholderColor: UIColor = .init(hexString: "717171"),
                      isSecureTextEntry: Bool = false) -> SkyFloatingLabelTextField {
        SkyFloatingLabelTextField().apply(title, placeholder: placeholder, titleFont: titleFont,
                                          placeholderFont: placeholderFont, titleColor: titleColor,
                                          placeholderColor: placeholderColor, isSecureTextEntry: isSecureTextEntry)
    }
    
}

import ReactiveCocoa
import ReactiveSwift
extension Reactive where Base: SkyFloatingLabelTextField {
    var errorMessage: BindingTarget<String?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            base.errorMessage = value
        }
    }
    
}
