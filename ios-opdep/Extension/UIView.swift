//
//  UIView.swift

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func addSubviews(_ subviews: UIView...) {
        addSubviews(subviews)
    }
    
    func isVisible(in view: UIView?) -> Bool {
        guard let view = view else { return true }
        let viewport = view.convert(bounds, to: self)
        guard viewport.intersects(view.bounds) else {
            return false
        }
        
        return isVisible(in: view.superview)
    }
    
    @discardableResult
    func withBorder(width: CGFloat,
                    cornerRadius: CGFloat = 0,
                    color: UIColor? = .clear) -> Self {
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
        layer.cornerRadius = cornerRadius
        return self
    }
    
    // MARK: - Utils
    func findFirstResponder() -> UIView? {
        guard !isFirstResponder else { return self }
        for view in subviews {
            let match = view.findFirstResponder()
            if match != nil {
                return match
            }
        }
        return nil
    }
    
    func dropShadow(color: UIColor,
                    opacity: Float = 1,
                    offSet: CGSize,
                    radius: CGFloat = 1,
                    scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }

    func whiteShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.init(hexString: "000000", alpha: 0.2).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 4
    }
    
    func imageFromView(scale: CGFloat) -> Data? {
        takeSnapshot(scale: scale)?.pngData()
    }
    
    func takeSnapshot(scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale * scale)
            defer { UIGraphicsEndImageContext() }
            drawHierarchy(in: bounds, afterScreenUpdates: true)
            return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func pdfFromView(saveToDocumentsWithFileName fileName: String) -> URL? {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, bounds, nil)
        
        let rect = CGRect(origin: .zero,
                          size: UIScreen.main.bounds.size)
        
        UIGraphicsBeginPDFPageWithInfo(rect, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext(),
            let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first else { return nil }
        layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        let fileUrl = documentsURL.appendingPathComponent("\(fileName).pdf")
        // swiftlint:disable force_try
        try! pdfData.write(to: fileUrl,
                           options: .atomic)
        return fileUrl
    }
    
    func addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat) {
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor

        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round

        shapeLayer.lineDashPattern = [5, 5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath

        self.layer.addSublayer(shapeLayer)
    }
    
    @IBInspectable
    var cornerRadiusNew: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidthNew: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColorNew: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadiusNew: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor(red: 0.135, green: 0.368, blue: 0.771, alpha: 0.11).cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowOpacity = 1
            layer.shadowRadius = newValue
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable
    var shadowRadiusTopNew: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor(red: 0.922, green: 0.937, blue: 0.973, alpha: 0.7).cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowOpacity = 1
            layer.shadowRadius = newValue
            layer.masksToBounds = false
            layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: -layer.shadowRadius, width: bounds.width, height: layer.shadowRadius)).cgPath
        }
    }
    
    func setGradientBackgroundNew(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

       layer.insertSublayer(gradientLayer, at: 0)
    }

}

extension UIImage {
    func resizedToMB(size: Int) -> UIImage? {
        guard let imageData = self.pngData() else { return nil }

        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB

        while imageSizeKB > Double(size) * 1000 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                  let imageData = resizedImage.pngData()
                else { return nil }

            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }

        return resizingImage
    }
}
