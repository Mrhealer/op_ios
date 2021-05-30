//
//  StyleButton.swift

import UIKit

class StyleButton: UIButton {
    var rounded: Bool
    var cornerRadius: CGFloat?
    let minHeight: CGFloat?
    required init(title: String? = nil,
                  titleFont: UIFont = UIFont.primary(),
                  titleColor: UIColor? = UIColor.Basic.primary,
                  selectedTitleColor: UIColor? = UIColor.Basic.primary,
                  image: UIImage? = nil,
                  backgroundColor: UIColor? = UIColor.clear,
                  selectedBackgroundColor: UIColor? = UIColor.Basic.primary,
                  minHeight: CGFloat? = nil,
                  rounded: Bool = false,
                  cornerRadius: CGFloat? = nil,
                  borderColor: CGColor? = nil,
                  borderWidth: CGFloat = 0.0,
                  horizontalAlignment: UIControl.ContentHorizontalAlignment = .center,
                  verticalAlignment: UIControl.ContentVerticalAlignment = .center,
                  contentInsets: UIEdgeInsets = .zero) {
        self.rounded = rounded
        self.cornerRadius = cornerRadius
        self.minHeight = minHeight
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        setTitleColor(titleColor, for: .normal)
        setTitleColor(selectedTitleColor, for: .selected)
        setTitleColor(.lightGray, for: .disabled)
        setBackgroundColor(backgroundColor, forState: .normal)
        setBackgroundColor(selectedBackgroundColor, forState: .selected)
        self.titleLabel?.font = titleFont
        layer.borderColor = borderColor
        layer.borderWidth = borderWidth
        contentHorizontalAlignment = horizontalAlignment
        contentVerticalAlignment = verticalAlignment
        contentEdgeInsets = contentInsets
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        guard let minHeight = minHeight else { return }
        snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(minHeight)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard rounded else { return }
        layer.masksToBounds = true
        guard let cornerRadius = cornerRadius else {
            layer.cornerRadius = layer.bounds.height / 2
            return
        }
        layer.cornerRadius = cornerRadius
    }
}

extension StyleButton {
    func apply(title: String, subTitle: String, color: UIColor) {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: title,
                                                   attributes: [.font: UIFont.font(style: .regular,
                                                                                   size: 13)]))
        attributedString.append(NSAttributedString(string: subTitle,
                                                   attributes: [.font: UIFont.font(style: .lightItalic,
                                                                                   size: 10)]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0,
                                                     length: attributedString.length))
                                              
        setAttributedTitle(attributedString, for: .normal)
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 0
        titleLabel?.textColor = color
    }
}

extension UIButton {
    func underline() {
        if let textString = self.titleLabel?.text {
            
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: textString.count))
            self.setAttributedTitle(attributedString, for: .normal)
        }
        
    }
}
