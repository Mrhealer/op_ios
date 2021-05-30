//
//  UIImage.swift

import UIKit

extension UIImage {
    struct Common {
        static let background = UIImage(named: "background")
        static let iconBack = UIImage(named: "iconBack")
        static let appLogo = UIImage(named: "oposAppLogo")
        static let chevronRight = UIImage(named: "chevron-right")
    }
    
    struct CallHotline {
        static let callPhoneNumber = UIImage(named: "icon_call")
        static let messenger = UIImage(named: "icon_mess")
    }
    
    enum Rate {
        static let title = UIImage(named: "icon_title_rate")
        static let star  = UIImage(named: "icon_star")
        static let starActive  = UIImage(named: "icon_star_active")
    }
    
    enum Date {
        static let chevronRight = UIImage(named: "icon_chevron_right")
        static let chevronLeft = UIImage(named: "icon_chevron_left")
    }
}

// MARK: - Utils
extension UIImage {
    class func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }

    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width + insets.left + insets.right,
                   height: size.height + insets.top + insets.bottom),
            false,
            scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
    /// Overlay Model
    enum OverlayMode {
        /// Place overlay at the center of image with its original size
        case center
        
        /// Place overlay with background image' size
        case fill
    }
    
    /// Generate new image by overlaying given image on top of instance
    ///
    /// - parameter image: Image to be used as overlay
    /// - parameter position: Overlay position, default it `.center`
    /// - returns: An image with overlay
    func overlay(with image: UIImage?,
                 position: OverlayMode = .center) -> UIImage? {
        guard let overlay = image else { return self }
        let backgroundImage = self
        
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0,
                              width: backgroundImage.size.width,
                              height: backgroundImage.size.height)
        backgroundImage.draw(in: areaSize)
        switch position {
        case .center:
            let overlaySize = overlay.size
            let targetArea = CGRect(x: (areaSize.width - overlaySize.width) / 2,
                                    y: (areaSize.height - overlaySize.height) / 2,
                                    width: overlaySize.width,
                                    height: overlaySize.height)
            overlay.draw(in: targetArea, blendMode: .normal, alpha: 1.0)
        case .fill:
            overlay.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        }

        let merged = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return merged
    }
    
    func maskWithColor(color: UIColor) -> UIImage? {
        guard let maskImage = cgImage else { return nil }

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(data: nil,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: 0,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else { return nil }

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
    // MARK: - resized
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resized(toKB: Double) -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1024

        while imageSizeKB > toKB {
            let percent: CGFloat = imageSizeKB > 10000.0 ? 0.3 : 0.75
            guard let resizedImage = resizingImage.resized(withPercentage: percent),
                  let imageData = resizedImage.pngData()
                else { return nil }

            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1024.0
        }

        return resizingImage
    }
}
