//
//  StickerView.swift
//  StickerView

// BaseView này được chỉnh sửa code StickerView từ link dưới:
// https://github.com/injap2017/StickerView

import UIKit
import ReactiveSwift

enum TransformViewType: Int {
    case close = 0
    case rotate
    case flip
    case scrollState
    case zoom
    case scaleFromRight
    case scaleFromLeft
    case scaleFromTop
}

enum BaseViewPosition: Int {
    case topLeft = 0
    case topRight
    case bottomLeft
    case bottomRight
    case middleTop
    case middleRight
    case middleBottom
    case middleLeft
}

@inline(__always) func CGRectGetCenter(_ rect: CGRect) -> CGPoint {
    return CGPoint(x: rect.midX, y: rect.midY)
}

@inline(__always) func CGRectScale(_ rect: CGRect, wScale: CGFloat, hScale: CGFloat) -> CGRect {
    return CGRect(x: rect.origin.x,
                  y: rect.origin.y,
                  width: rect.size.width * wScale,
                  height: rect.size.height * hScale)
}

@inline(__always) func CGAffineTransformGetAngle(_ transform: CGAffineTransform) -> CGFloat {
    return atan2(transform.b, transform.a)
}

@inline(__always) func CGPointGetDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
    let fx = point2.x - point1.x
    let fy = point2.y - point1.y
    return sqrt(fx * fx + fy * fy)
}

class BaseView: UIView {
    private let minSize: CGSize = CGSize(width: 40, height: 40)
    let contentView: UIView
    private let cornerRadius: CGFloat = 0
    var enableFlip: Bool = true
    var enableZoom: Bool = true
    
    func showEditingHandlers(status: Bool) {
        setEnableClose(status)
        setEnableRotate(status)
        setEnableFlip(status)
        setEnableZoom(status)
        setEnableScaleRight(status)
        setEnableScaleLeft(status)
        setEnableScaleTop(status)
        setEnableMove(status)
        setEnableRotato(status)
        setEnablePinch(status)
        setEnableScrollState(status)
        contentView.withBorder(width: status ? 1 : 0, color: .init(hexString: "444444"))
//        contentView.addDashedBorder(strokeColor: .init(hexString: "444444"), lineWidth: status ? 1 : 0)
//        contentView.layer.borderWidth = status ? 1 : 0
    }
    
    private var _minimumSize: NSInteger = 0
    var minimumSize: NSInteger {
        set {
            _minimumSize = max(newValue, defaultMinimumSize)
        }
        get {
            return _minimumSize
        }
    }
    
    private var _outlineBorderColor: UIColor = .clear
    var outlineBorderColor: UIColor {
        set {
            _outlineBorderColor = newValue
            contentView.layer.borderColor = _outlineBorderColor.cgColor
        }
        get {
            return _outlineBorderColor
        }
    }
    
    private let border = CAShapeLayer()
    
    init(contentView: UIView) {
        defaultInset = 11
        defaultMinimumSize = 4 * self.defaultInset
        self.contentView = contentView
        var frame = contentView.frame
        frame = CGRect(x: 0,
                       y: 0,
                       width: frame.size.width + CGFloat(self.defaultInset) * 2,
                       height: frame.size.height + CGFloat(self.defaultInset) * 2)
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addGestureRecognizer(moveGesture)
        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(rotatoGesture)
        pinchGesture.delegate = self
        rotatoGesture.delegate = self
        
        // Setup content view
        contentView.center = CGRectGetCenter(self.bounds)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.allowsEdgeAntialiasing = true
        addSubview(contentView)
        
        // Setup editing handlers
        setPosition(.topLeft, forHandler: .close)
        addSubview(closeImageView)
        setPosition(.bottomLeft, forHandler: .rotate)
        addSubview(rotateImageView)
        setPosition(.topRight, forHandler: .flip)
        addSubview(flipImageView)
        setPosition(.topRight, forHandler: .scrollState)
        addSubview(scrollStateImageView)
        setPosition(.bottomRight, forHandler: .zoom)
        addSubview(zoomImageView)
        setPosition(.middleRight, forHandler: .scaleFromRight)
        addSubview(scaleRightImageView)
        setPosition(.middleLeft, forHandler: .scaleFromLeft)
        addSubview(scaleLeftImageView)
        setPosition(.middleTop, forHandler: .scaleFromTop)
        addSubview(scaleTopImageView)
        
        showEditingHandlers(status: true)
        enableFlip = true
        
        minimumSize = defaultMinimumSize
        outlineBorderColor = .black
    }
    
    func updateFrame() {
        var frame = contentView.frame
        frame = CGRect(x: 0,
                       y: 0,
                       width: frame.size.width + CGFloat(self.defaultInset) * 2,
                       height: frame.size.height + CGFloat(self.defaultInset) * 2)
        self.frame = frame
    }
    
    func drawBorder(isSelected: Bool) {
        if isSelected {
            border.strokeColor = self.outlineBorderColor.cgColor
            border.fillColor = nil
            border.lineDashPattern = [4, 2]
            border.lineWidth = 2.0
            border.frame = self.contentView.bounds
            let bezierPath = UIBezierPath(roundedRect: bounds,
                                          cornerRadius: cornerRadius)
            bezierPath.lineJoinStyle = CGLineJoin.round
            border.path =  bezierPath.cgPath
            self.layer.addSublayer(border)
        } else {
            self.border.removeFromSuperlayer()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage?, forHandler handler: TransformViewType) {
        switch handler {
        case .close:
            closeImageView.image = image
        case .rotate:
            rotateImageView.image = image
        case .flip:
            flipImageView.image = image
        case .scrollState:
        scrollStateImageView.image = image
        case .zoom:
            zoomImageView.image = image
        case .scaleFromRight:
            scaleRightImageView.image = image
        case .scaleFromLeft:
            scaleLeftImageView.image = image
        case .scaleFromTop:
            scaleTopImageView.image = image
        }
    }
    
    func setPosition(_ position: BaseViewPosition, forHandler handler: TransformViewType) {
        let origin = contentView.frame.origin
        let size = contentView.frame.size
        
        var handlerView: UIImageView?
        switch handler {
        case .close:
            handlerView = closeImageView
        case .rotate:
            handlerView = rotateImageView
        case .flip:
            handlerView = flipImageView
        case .scrollState:
            handlerView = scrollStateImageView
        case .zoom:
            handlerView = zoomImageView
        case .scaleFromRight:
            handlerView = scaleRightImageView
        case .scaleFromLeft:
            handlerView = scaleLeftImageView
        case .scaleFromTop:
            handlerView = scaleTopImageView
        }
        
        switch position {
        case .topLeft:
            handlerView?.center = origin
            handlerView?.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        case .topRight:
            handlerView?.center = CGPoint(x: origin.x + size.width, y: origin.y)
            handlerView?.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        case .bottomLeft:
            handlerView?.center = CGPoint(x: origin.x, y: origin.y + size.height)
            handlerView?.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
        case .bottomRight:
            handlerView?.center = CGPoint(x: origin.x + size.width, y: origin.y + size.height)
            handlerView?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        case .middleRight:
            handlerView?.center = CGPoint(x: origin.x + size.width, y: origin.y + size.height / 2)
            handlerView?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        case .middleLeft:
            handlerView?.center = CGPoint(x: origin.x, y: origin.y + size.height / 2)
            handlerView?.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        case .middleTop:
            handlerView?.center = CGPoint(x: origin.x + size.width / 2, y: origin.y)
            handlerView?.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        default:
            break
        }
        
        handlerView?.tag = position.rawValue
    }
    
    func setHandlerSize(_ size: Int) {
        if size <= 0 {
            return
        }
        
        defaultInset = NSInteger(round(Float(size) / 3))
        defaultMinimumSize = 4 * defaultInset
        minimumSize = max(minimumSize, defaultMinimumSize)
        
        let originalCenter = center
        let originalTransform = transform
        var frame = contentView.frame
        frame = CGRect(x: 0,
                       y: 0,
                       width: frame.size.width + CGFloat(self.defaultInset) * 2,
                       height: frame.size.height + CGFloat(self.defaultInset) * 2)
        
        contentView.removeFromSuperview()
        
        transform = CGAffineTransform.identity
        self.frame = frame
        
        contentView.center = CGRectGetCenter(bounds)
        addSubview(contentView)
        sendSubviewToBack(contentView)
        
        let handlerFrame = CGRect(x: 0,
                                  y: 0,
                                  width: defaultInset * 2,
                                  height: defaultInset * 2)
        closeImageView.frame = handlerFrame
        setPosition(BaseViewPosition(rawValue: closeImageView.tag) ?? .topLeft,
                    forHandler: .close)
        rotateImageView.frame = handlerFrame
        setPosition(BaseViewPosition(rawValue: rotateImageView.tag) ?? .bottomLeft,
                         forHandler: .rotate)
        flipImageView.frame = handlerFrame
        setPosition(BaseViewPosition(rawValue: flipImageView.tag) ?? .topRight,
                         forHandler: .flip)
        scrollStateImageView.frame = handlerFrame
        setPosition(BaseViewPosition(rawValue: scrollStateImageView.tag) ?? .topRight,
                         forHandler: .scrollState)
        zoomImageView.frame = handlerFrame
        setPosition(BaseViewPosition(rawValue: zoomImageView.tag) ?? .bottomRight,
                         forHandler: .zoom)
        scaleRightImageView.frame = handlerFrame
        setPosition(BaseViewPosition(rawValue: scaleRightImageView.tag) ?? .middleRight,
                         forHandler: .scaleFromRight)
        scaleLeftImageView.frame = handlerFrame
        setPosition(BaseViewPosition(rawValue: scaleLeftImageView.tag) ?? .middleLeft,
                         forHandler: .scaleFromLeft)
        scaleTopImageView.frame = handlerFrame
        setPosition(BaseViewPosition(rawValue: scaleTopImageView.tag) ?? .middleTop,
                         forHandler: .scaleFromTop)
        center = originalCenter
        transform = originalTransform
    }
    
    var defaultInset: NSInteger
    private var defaultMinimumSize: NSInteger
    
    private var beginningPoint = CGPoint.zero
    private var beginningCenter = CGPoint.zero
    
    private var initialFrame = CGRect.zero
    var initialBounds = CGRect.zero
    var initialDistance: CGFloat = 0
    var initialPoint: CGPoint = .zero
    private var deltaAngle: CGFloat = 0
    
    private lazy var moveGesture = {
        return UIPanGestureRecognizer(target: self,
                                      action: #selector(handleMoveGesture(_:)))
    }()
    private lazy var rotateImageView: UIImageView = {
        let rotateImageView = UIImageView(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: defaultInset * 2,
                                                        height: defaultInset * 2))
        rotateImageView.contentMode = .scaleAspectFit
        rotateImageView.backgroundColor = UIColor.clear
        rotateImageView.isUserInteractionEnabled = true
        rotateImageView.addGestureRecognizer(rotateGesture)
        
        return rotateImageView
    }()
    
    private lazy var closeImageView: UIImageView = {
        let closeImageview = UIImageView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: defaultInset * 2,
                                                       height: defaultInset * 2))
        closeImageview.contentMode = .scaleAspectFit
        closeImageview.backgroundColor = UIColor.clear
        closeImageview.isUserInteractionEnabled = true
        closeImageview.addGestureRecognizer(closeGesture)
        return closeImageview
    }()
    
    private lazy var zoomImageView: UIImageView = {
        let zoomImageView = UIImageView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: defaultInset * 2,
                                                      height: defaultInset * 2))
        zoomImageView.contentMode = .scaleAspectFit
        zoomImageView.backgroundColor = UIColor.clear
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.addGestureRecognizer(zoomGesture)
        return zoomImageView
    }()
    
    private lazy var flipImageView: UIImageView = {
        let flipImageView = UIImageView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: defaultInset * 2,
                                                      height: defaultInset * 2))
        flipImageView.contentMode = .scaleAspectFit
        flipImageView.backgroundColor = UIColor.clear
        flipImageView.isUserInteractionEnabled = true
        flipImageView.addGestureRecognizer(flipGesture)
        return flipImageView
    }()
    
    private lazy var scrollStateImageView: UIImageView = {
        let scrollStateImageView = UIImageView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: defaultInset * 2,
                                                      height: defaultInset * 2))
        scrollStateImageView.contentMode = .scaleAspectFit
        scrollStateImageView.backgroundColor = UIColor.clear
        scrollStateImageView.isUserInteractionEnabled = true
        scrollStateImageView.addGestureRecognizer(scrollStateGesture)
        return scrollStateImageView
    }()
    
    private lazy var scaleRightImageView: UIImageView = {
        let scaleRightImageView = UIImageView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: defaultInset * 2,
                                                            height: defaultInset * 2))
        scaleRightImageView.contentMode = .scaleAspectFit
        scaleRightImageView.backgroundColor = UIColor.clear
        scaleRightImageView.isUserInteractionEnabled = true
        scaleRightImageView.addGestureRecognizer(scaleRightGesture)
        return scaleRightImageView
    }()
    
    private lazy var scaleLeftImageView: UIImageView = {
        let scaleLeftImageView = UIImageView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: defaultInset * 2,
                                                            height: defaultInset * 2))
        scaleLeftImageView.contentMode = .scaleAspectFit
        scaleLeftImageView.backgroundColor = UIColor.clear
        scaleLeftImageView.isUserInteractionEnabled = true
        scaleLeftImageView.addGestureRecognizer(scaleLeftGesture)
        return scaleLeftImageView
    }()
    
    private lazy var scaleTopImageView: UIImageView = {
        let scaleTopImageView = UIImageView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: defaultInset * 2,
                                                            height: defaultInset * 2))
        scaleTopImageView.contentMode = .scaleAspectFit
        scaleTopImageView.backgroundColor = UIColor.clear
        scaleTopImageView.isUserInteractionEnabled = true
        scaleTopImageView.addGestureRecognizer(scaleTopGesture)
        return scaleTopImageView
    }()
    
    private lazy var rotateGesture = {
        return UIPanGestureRecognizer(target: self,
                                      action: #selector(handleRotateGesture(_:)))
    }()
    
    private lazy var zoomGesture = {
        return UIPanGestureRecognizer(target: self,
                                      action: #selector(handleZoomGesture(_:)))
    }()
    
    lazy var closeGesture = {
        return UITapGestureRecognizer(target: self,
                                      action: #selector(handleCloseGesture(_:)))
    }()
    
    private lazy var flipGesture = {
        return UITapGestureRecognizer(target: self,
                                      action: #selector(handleFlipGesture(_:)))
    }()
    
    private lazy var scrollStateGesture = {
        return UITapGestureRecognizer(target: self,
                                      action: #selector(handleScrollStateGesture(_:)))
    }()
    
    private lazy var dragGesture = {
        return UIPanGestureRecognizer(target: self,
                                      action: #selector(handleMoveGesture(_:)))
    }()
    
    private lazy var pinchGesture: UIPinchGestureRecognizer = {
        return UIPinchGestureRecognizer(target: self,
                                        action: #selector(handlePinchGesture(_:)))
    }()
    
    private lazy var rotatoGesture: UIRotationGestureRecognizer = {
        return UIRotationGestureRecognizer(target: self,
                                           action: #selector(handleRotatoGesture(_:)))
    }()
    
    private lazy var scaleRightGesture = {
        return UIPanGestureRecognizer(target: self,
                                      action: #selector(handleScaleRightGesture(_:)))
    }()
    
    private lazy var scaleLeftGesture = {
        return UIPanGestureRecognizer(target: self,
                                      action: #selector(handleScaleLeftGesture(_:)))
    }()
    
    private lazy var scaleTopGesture = {
        return UIPanGestureRecognizer(target: self,
                                      action: #selector(handleScaleTopGesture(_:)))
    }()
    
    // MARK: - Gesture Handlers
    
    @objc func handleRotatoGesture(_ gesture: UIRotationGestureRecognizer) {
        transform = transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    @objc func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            initialBounds = bounds
            recognizer.scale = 1
        case .changed:
            var scale = recognizer.scale
            let minimumScale = CGFloat(minimumSize) / min(initialBounds.size.width, initialBounds.size.height)
            scale = max(scale, minimumScale)
            let scaledBounds = CGRectScale(initialBounds,
                                           wScale: scale,
                                           hScale: scale)
            let oldBounds = bounds
            bounds = scaledBounds
            if rePosition() { bounds = oldBounds }
        default:
            return
        }
    }
    
    @objc func handleScaleTopGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: superview)
        switch recognizer.state {
        case .began:
            setAnchorPoint(.init(x: 0.5, y: 1))
            initialBounds = bounds
            initialPoint = touchLocation
        case .changed:
            let radians = atan2(self.transform.b, self.transform.a)
            let degrees = radians * 180 / .pi
            let ratioY: CGFloat = (degrees < 45 && degrees > -45) ? 1 : -1
            let ratioX: CGFloat = (degrees < 135 && degrees > 45) ? -1 : 1
            var distance = (touchLocation.y - initialPoint.y) * ratioY
            let absDegrees = fabsf(Float(degrees))
            if absDegrees > 45 && absDegrees < 135 {
                distance = (touchLocation.x - initialPoint.x) * ratioX
            }
            var height = initialBounds.height - distance
            if height < minSize.height { height = minSize.height }
            setAnchorPoint(.init(x: 0.5, y: 1))
            bounds = CGRect(origin: .zero,
                            size: CGSize(width: bounds.width,
                                         height: height))
            setNeedsDisplay()
        case .ended:
            setAnchorPoint(.init(x: 0.5, y: 0.5))
        default:
            break
        }
    }
    
    @objc func handleScaleRightGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: superview)
        switch recognizer.state {
        case .began:
            setAnchorPoint(.init(x: 0, y: 0.5))
            initialBounds = bounds
            initialPoint = touchLocation
        case .changed:
            let radians = atan2(self.transform.b, self.transform.a)
            let degrees = radians * 180 / .pi
            let ratioX: CGFloat = (degrees < 45 && degrees > -45) ? 1 : -1
            let ratioY: CGFloat = (degrees < 135 && degrees > 45) ? 1 : -1
            var distance = (initialPoint.x - touchLocation.x) * ratioX
            let absDegrees = fabsf(Float(degrees))
            if absDegrees > 45 && absDegrees < 135 {
                distance = (initialPoint.y - touchLocation.y) * ratioY
            }
            var width = initialBounds.width - distance
            
            if width < minSize.width { width = minSize.width }
            setAnchorPoint(.init(x: 0, y: 0.5))
            bounds = CGRect(origin: .zero,
                            size: CGSize(width: width,
                                         height: bounds.height))
            setNeedsDisplay()
        case .ended:
            setAnchorPoint(.init(x: 0.5, y: 0.5))
        default:
            break
        }
    }
    
    @objc func handleScaleLeftGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: superview)
        switch recognizer.state {
        case .began:
            setAnchorPoint(.init(x: 1, y: 0.5))
            initialBounds = bounds
            initialPoint = touchLocation
        case .changed:
            let distance = touchLocation.x - initialPoint.x
            var width = initialBounds.width - distance
            if width < minSize.width { width = minSize.width }
            setAnchorPoint(.init(x: 1, y: 0.5))
            bounds = CGRect(origin: .zero,
                            size: CGSize(width: width,
                                         height: bounds.height))
            setNeedsDisplay()
        case .ended:
            setAnchorPoint(.init(x: 0.5, y: 0.5))
        default:
            break
        }
    }
    
    @objc func handleMoveGesture(_ recognizer: UIPanGestureRecognizer) {
        // TODO: Chỉnh sửa di chuyển ảnh (khi di zoom ảnh ảnh bị căn từ giữa ra)
        if recognizer.state == .began || recognizer.state == .changed {
            let translation = recognizer.translation(in: self.superview)
            if let view = recognizer.view {
                view.center = CGPoint(x: view.center.x + translation.x,
                                      y: view.center.y + translation.y)
            }
            recognizer.setTranslation(CGPoint.zero, in: self.superview)
        }
//        let touchLocation = recognizer.location(in: superview)
//        switch recognizer.state {
//        case .began:
//            beginningPoint = touchLocation
//            beginningCenter = center
//        case .changed:
//            let oldCenter = center
//            center = CGPoint(x: beginningCenter.x + (touchLocation.x - beginningPoint.x),
//                             y: beginningCenter.y + (touchLocation.y - beginningPoint.y))
//            if rePosition() { center = oldCenter }
//        default:
//            break
//        }
    }
    
    private func rePosition() -> Bool {
//        guard let parent = superview else { return false }
//        let frame = self.frame
//        if frame.origin.x < 60 - frame.size.width {
//            return true
//        }
//        if frame.origin.x > parent.frame.size.width - 60 {
//            return true
//        }
//        if frame.origin.y < 60 - frame.size.height {
//            return true
//        }
//        if frame.origin.y > parent.frame.size.height - 60 {
//            return true
//        }
        return false
    }
    
    @objc func handleZoomGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: superview)
        let center = self.center
        switch recognizer.state {
        case .began:
            initialBounds = bounds
            initialDistance = CGPointGetDistance(point1: center,
                                                 point2: touchLocation)
        case .changed:
            var scale = CGPointGetDistance(point1: center,
                                           point2: touchLocation) / initialDistance
            let minimumScale = CGFloat(minimumSize) / min(initialBounds.size.width, initialBounds.size.height)
            scale = max(scale, minimumScale)
            let scaledBounds = CGRectScale(initialBounds,
                                           wScale: scale,
                                           hScale: scale)
            bounds = scaledBounds
            setNeedsDisplay()
        default:
            break
        }
    }
    
    @objc func handleRotateGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: superview)
        let center = self.center
        switch recognizer.state {
        case .began:
            self.deltaAngle = CGFloat(atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))) - CGAffineTransformGetAngle(transform)
            initialBounds = bounds
            initialDistance = CGPointGetDistance(point1: center,
                                                 point2: touchLocation)
        case .changed:
            let angle = atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))
            let angleDiff = Float(deltaAngle) - angle
            transform = CGAffineTransform(rotationAngle: CGFloat(-angleDiff))
        default:
            break
        }
    }
    
    @objc func handleCloseGesture(_ recognizer: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    
    @objc func handleFlipGesture(_ recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = self.contentView.transform.scaledBy(x: -1,
                                                                             y: 1)
        }
    }
    
    @objc func handleScrollStateGesture(_ recognizer: UITapGestureRecognizer) {
    }
    
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x,
                               y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x,
                               y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
    
    func setEnableClose(_ enableClose: Bool) {
        closeImageView.isHidden = !enableClose
        closeImageView.isUserInteractionEnabled = enableClose
    }
    
    func setEnableRotate(_ enableRotate: Bool) {
        rotateImageView.isHidden = !enableRotate
        rotateImageView.isUserInteractionEnabled = enableRotate
    }
    
    func setEnableFlip(_ enableFlip: Bool) {
        flipImageView.isHidden = !enableFlip
        flipImageView.isUserInteractionEnabled = enableFlip
    }
    
    func setEnableScrollState(_ enableScrollState: Bool) {
        scrollStateImageView.isHidden = !enableScrollState
        scrollStateImageView.isUserInteractionEnabled = enableScrollState
    }
    
    func setEnableZoom(_ enableZoom: Bool) {
        zoomImageView.isHidden = !enableZoom
        zoomImageView.isUserInteractionEnabled = enableZoom
    }
    
    func setEnableScaleRight(_ enableScaleRight: Bool) {
        scaleRightImageView.isHidden = !enableScaleRight
        scaleRightImageView.isUserInteractionEnabled = enableScaleRight
    }
    
    func setEnableScaleLeft(_ enableScaleLeft: Bool) {
        scaleLeftImageView.isHidden = !enableScaleLeft
        scaleLeftImageView.isUserInteractionEnabled = enableScaleLeft
    }
    
    func setEnableScaleTop(_ enableScaleTop: Bool) {
        scaleTopImageView.isHidden = !enableScaleTop
        scaleTopImageView.isUserInteractionEnabled = enableScaleTop
    }
    
    func setEnableMove(_ enableMove: Bool) {
        if enableMove {
            if containsGestureRecognizer(find: moveGesture) { return }
            addGestureRecognizer(moveGesture)
        } else {
            removeGestureRecognizer(moveGesture)
        }
    }
    
    func setEnablePinch(_ enablePinch: Bool) {
        if enablePinch {
            if containsGestureRecognizer(find: pinchGesture) { return }
            addGestureRecognizer(pinchGesture)
        } else {
            removeGestureRecognizer(pinchGesture)
        }
    }
    
    func setEnableRotato(_ enableRotato: Bool) {
        if enableRotato {
            if containsGestureRecognizer(find: rotatoGesture) { return }
            addGestureRecognizer(rotatoGesture)
        } else {
            removeGestureRecognizer(rotatoGesture)
        }
    }
    
    private func containsGestureRecognizer(find: UIGestureRecognizer) -> Bool {
       if let recognizers = gestureRecognizers {
           for recognizer in recognizers where recognizer == find {
               return true
           }
       }
       return false
    }
}

extension BaseView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
