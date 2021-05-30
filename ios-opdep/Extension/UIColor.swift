//
//  UIColor.swift

import UIKit
extension UIColor {
    enum Basic {
        static let primary = UIColor(hexString: "#0D0F1E")
        static let secondary = UIColor(hexString: "#122952")
        static let white = UIColor.white
        static let black = UIColor.black
        static let red = UIColor(hexString: "#DD2121")
        static let unselected = UIColor(hexString: "#6D6D6D")
        static let background = UIColor(hexString: "E5E5E5")
        static let priceDiscount = UIColor(hexString: "f57224")
        static let ping = UIColor(hexString: "FFB0BD")
    }
    
    enum BottomBar {
        static let text = Basic.black
        static let textActive = UIColor.init(hexString: "2A8280")
        static let bgActive = UIColor.init(hexString: "D8EDEB")
    }
    
    enum Editor {
        static let bgMenuSelection = UIColor.init(hexString: "f5f5f5")
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexint = Int(UIColor.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        // Create color object, specifying alpha as well
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    func hexStringFromColor() -> String {
        let components = self.cgColor.components
        let red: CGFloat = components?[0] ?? 0.0
        let green: CGFloat = components?[1] ?? 0.0
        let blue: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
        return hexString
     }
}
