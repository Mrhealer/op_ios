//
//  EntityView.swift
//  OPOS
//
//  Created by longbp on 8/22/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

private typealias Ri = R.image

class TextTransformable: BaseView {
    var styles: (Float, Float, Float) = (0, 0, 0)
    var fontSize: Float = 16
    let labelContent: StyleLabel
    init(text: String, size: Float = 16, fontName: String? = "Livvic-Bold", textColor: UIColor = .black, textAlignment: NSTextAlignment = .center) {
        fontSize = size
        var styleFont = UIFont.important(size: CGFloat(size))
        if let name = fontName,
            let font = UIFont(name: name,
                              size: CGFloat(size)) {
            styleFont = font
        }
        labelContent = StyleLabel(text: text,
                                  font: styleFont,
                                  textColor: textColor,
                                  textAlignment: textAlignment)
        super.init(contentView: labelContent)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        setImage(Ri.icon_delete_frame(), forHandler: TransformViewType.close)
        setImage(Ri.icon_rotate_frame(), forHandler: TransformViewType.rotate)
        setImage(Ri.icon_resize_frame(), forHandler: TransformViewType.scaleFromRight)
        setHandlerSize(30)
        showEditingHandlers(status: true)
    }
    
    func apply(styles: (Float, Float, Float)) -> CGFloat {
        self.styles = styles
        return labelContent.apply(styles: styles)
    }
    
    override func showEditingHandlers(status: Bool) {
        super.showEditingHandlers(status: status)
        setEnableZoom(false)
        setEnableScaleTop(false)
        setEnableScaleLeft(false)
        setEnableFlip(false)
        setEnablePinch(false)
    }
    
    override func handleScaleRightGesture(_ recognizer: UIPanGestureRecognizer) {
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
            if width < 50 { width = 50 }
            setAnchorPoint(.init(x: 0, y: 0.5))
            var height: CGFloat = 50
            if labelContent.text != nil {
                height = labelContent.apply(styles: styles, calculatedWidth: width - CGFloat(defaultInset * 2))
            }
            bounds = CGRect(origin: .zero,
                            size: CGSize(width: width,
                                         height: height + 40))
            setNeedsDisplay()
        case .ended:
            setAnchorPoint(.init(x: 0.5, y: 0.5))
        default:
            break
        }
    }
}

class ImageTransformable: BaseView {
    let imageView: UIImageView
    var url: URL?
    init(url: URL?,
         designSize: CGSize? = nil,
         contentMode: UIView.ContentMode = .scaleToFill) {
        var size = AppConstants.CreateDesign.designImageSize
        if let designSize = designSize { size = designSize }
        imageView = UIImageView(frame: .init(origin: .zero,
                                                 size: size))
        imageView.contentMode = contentMode
        self.url = url
        super.init(contentView: imageView)
        prepare()
    }
    
    init(image: UIImage,
         designSize: CGSize? = nil,
         contentMode: UIView.ContentMode = .scaleToFill) {
        var size = AppConstants.CreateDesign.designImageSize
        if let designSize = designSize { size = designSize }
        imageView = UIImageView(frame: .init(origin: .zero,
                                                 size: size))
        imageView.contentMode = contentMode
        imageView.image = image
        super.init(contentView: imageView)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        if let url = url { imageView.af.setImage(withURL: url) }
        setImage(Ri.icon_delete_frame(), forHandler: TransformViewType.close)
        setImage(Ri.icon_rotate_frame(), forHandler: TransformViewType.rotate)
        setImage(Ri.icon_resize_frame(), forHandler: TransformViewType.scaleFromRight)
        setImage(Ri.adjusted_ratio(), forHandler: TransformViewType.zoom)
        setImage(Ri.adjusted_vertical(), forHandler: TransformViewType.scaleFromTop)
        setHandlerSize(30)
        showEditingHandlers(status: true)
    }
    
    override func showEditingHandlers(status: Bool) {
        super.showEditingHandlers(status: status)
        setEnableScaleLeft(false)
        setEnableFlip(false)
    }
}

class FrameTransformable: BaseView {
    let id: String?
    var scrollState: Bool = true
    let styleFrame: StyleFrame
    init(frame: CGRect, id: String? = nil) {
        styleFrame = .init(frame: frame)
        self.id = id
        super.init(contentView: styleFrame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        setImage(Ri.icon_delete_frame(), forHandler: TransformViewType.close)
        setImage(Ri.icon_rotate_frame(), forHandler: TransformViewType.rotate)
        setImage(Ri.icon_resize_frame(), forHandler: TransformViewType.scaleFromRight)
        setImage(Ri.adjusted_ratio(), forHandler: TransformViewType.zoom)
        setImage(Ri.adjusted_vertical(), forHandler: TransformViewType.scaleFromTop)
        setImage(Ri.unlock_scroll_content(), forHandler: TransformViewType.scrollState)
        setHandlerSize(30)
        showEditingHandlers(status: true)
    }
    
    override func showEditingHandlers(status: Bool) {
        super.showEditingHandlers(status: status)
        setEnableScaleLeft(false)
        setEnableFlip(false)
        setEnablePinch(false)
        setEnableRotato(false)
    }
    
    override func handleScrollStateGesture(_ recognizer: UITapGestureRecognizer) {
        scrollState = !scrollState
        if scrollState {
            styleFrame.content.unlockActions()
            setImage(Ri.unlock_scroll_content(), forHandler: TransformViewType.scrollState)
        } else {
            styleFrame.content.lockActions()
            setImage(Ri.lock_scroll_content(), forHandler: TransformViewType.scrollState)
        }
    }
    
    override func handleCloseGesture(_ recognizer: UITapGestureRecognizer) {
        // notify when 
        super.handleCloseGesture(recognizer)
    }
}
