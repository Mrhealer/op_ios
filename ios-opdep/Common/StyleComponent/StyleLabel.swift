//
//  StyleLabel.swift

import UIKit

class StyleLabel: UILabel {
    
    var rounded: Bool?
    var cornerRadius: CGFloat?
    
    init(text: String? = nil,
         font: UIFont? = UIFont.primary(),
         textColor: UIColor? = .black,
         textAlignment: NSTextAlignment = .left,
         numberOfLines: Int = 0,
         rounded: Bool = false,
         cornerRadius: CGFloat = 0,
         backgroundColor: UIColor? = .clear) {
        super.init(frame: .zero)
        self.rounded = rounded
        self.cornerRadius = cornerRadius
        self.text = text
        self.font = font
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.backgroundColor = backgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let rounded = rounded else {return}
        if rounded {
            layer.masksToBounds = true
            guard let cornerRadius = cornerRadius else {
                layer.cornerRadius = layer.bounds.height / 2
                return
            }
            layer.cornerRadius = cornerRadius
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func apply(styles: (Float, Float, Float), calculatedWidth: CGFloat? = nil) -> CGFloat {
        let (interline, distance, shadow) = styles
        let string = text ?? ""
        let textFont = self.font ?? UIFont.font(style: .medium,
                                                size: 16)
        let attributedString = NSMutableAttributedString(string: string)
        
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        if interline < 0 {
            style.lineSpacing = 0
            style.maximumLineHeight = textFont.pointSize + CGFloat(interline)
        } else {
            style.lineSpacing = CGFloat(interline)
        }
        
        let ombraShadow = NSShadow()
        ombraShadow.shadowBlurRadius = 0.0
        ombraShadow.shadowOffset = CGSize(width: CGFloat(shadow),
                                          height: CGFloat(shadow))
        ombraShadow.shadowColor = UIColor.darkGray
        let attributes = [NSAttributedString.Key.shadow : ombraShadow,
                          NSAttributedString.Key.kern : CGFloat(distance),
                          NSAttributedString.Key.paragraphStyle : style ,
                          NSAttributedString.Key.font : textFont] as [NSAttributedString.Key: Any]
        let range = NSRange(location: 0,
                            length: string.count)
        attributedString.addAttributes(attributes,
                                       range: range)
        self.attributedText = attributedString
        var width = bounds.width
        if let calculatedWidth = calculatedWidth { width = calculatedWidth }
        return string.heightWithConstrainedWidth(width: width,
                                                 font: textFont,
                                                 attributes: attributes)
    }
}
