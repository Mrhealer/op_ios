//
//  UIFont.swift

import UIKit

extension UIFont {
    
    enum FontStyles {
        case regular, italic, light, lightItalic, bold, boldItalic, medium, mediumItalic
        var name: String {
            switch self {
            case .regular:              return "OpenSans-Regular"
            case .italic:               return "OpenSans-Italic"
            case .light:                return "OpenSans-Light"
            case .lightItalic:          return "OpenSans-LightItalic"
            case .bold:                 return "OpenSans-Bold"
            case .boldItalic:           return "OpenSans-BoldItalic"
            case .medium:               return "OpenSans-SemiBold"
            case .mediumItalic:         return "OpenSans-SemiBoldItalic"
            }
        }
    }
    
    static func font(style: FontStyles, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: style.name, size: size) else {
            // If we don't have the font, let's return at least the system's default on the requested size
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
        
    static func primary(size: CGFloat = 16) -> UIFont {
        font(style: .regular, size: size)
    }
    
    static func important(size: CGFloat = 22) -> UIFont {
        font(style: .bold, size: size)
    }
}
