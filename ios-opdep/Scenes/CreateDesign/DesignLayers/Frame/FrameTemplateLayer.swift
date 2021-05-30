//
//  FrameTemplateLayer.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/14/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class CopiedContent: UIImageView {
    var originalImage: UIImage?
}

class FrameTemplateLayer: PassthroughView {
    let maskImageView = UIImageView()
    let backgroundImageView = UIImageView()
    let viewModel: FrameTemplateLayerViewModel
    let boundsView = PassthroughView()
    let copiedContent = CopiedContent()
    let targetContent = UIView()
    var selectedFrameView: TemplateFrame?
    var frameViews: [TemplateFrame] = []
    let deleteButton = StyleButton(image: R.image.icon_delete_frame())
    init(viewModel: FrameTemplateLayerViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        addSubviews(backgroundImageView, maskImageView, targetContent, copiedContent, boundsView)
        buildBoundViewContent()
        [backgroundImageView, maskImageView].forEach {
            $0.frame = .zero
            $0.contentMode = .scaleAspectFill
        }
        boundsView.frame = .zero
        boundsView.withBorder(width: 1,
                              color: .black)
        boundsView.isHidden = true
        copiedContent.withBorder(width: 2,
                                 color: .red)
        copiedContent.isUserInteractionEnabled = true
        copiedContent.contentMode = .scaleAspectFill
        copiedContent.clipsToBounds = true
        copiedContent.alpha = 0.7
        
        targetContent.withBorder(width: 2,
                                 color: .red)
        targetContent.backgroundColor = .clear
        targetContent.isHidden = true
        
        viewModel.frames.producer.startWithValues { [weak self] in
            guard let sself = self, let frameLayerModel = sself.viewModel.frameLayerModel.value else { return }
            let ratioStandard = frameLayerModel.width / frameLayerModel.height
            sself.drawFrames(frames: $0,
                             ratioStandard: ratioStandard)
        }
        
        viewModel.selectedFrame.signal.skipNil().observeValues { [weak self] _ in
            guard let sself = self,
                let frameView = sself.selectedFrameView,
                let contentView = frameView.selectedContent else { return }
            sself.checkShouldAdjustDesign(contentView: contentView)
        }
        
        maskImageView.reactive.image <~ viewModel.frameLayerModel.signal
            .skipNil()
            .map { $0.mask }
            .skipNil()
            .map { UIImage(named: $0) }
        
        deleteButton.reactive.isHidden <~ viewModel.isExistedImage.negate()
        
        reactive.reset <~ viewModel.reset
        reactive.rotate <~ viewModel.rotate
        reactive.flip <~ viewModel.flip
        reactive.deselect <~ viewModel.deselect
        
        viewModel.selectedImages.signal.observeValues { [weak self] in
            self?.fillImages($0)
        }
    }
    
    private func fillImages(_ images: [UIImage?]) {
        viewModel.cachedImages.removeAll()
        var imageIndex: Int = 0
        for (index, frameView) in self.frameViews.enumerated() {
            if imageIndex == images.count { break }
            let frame = viewModel.frames.value[index]
            let count = frame.model.contents.count
            var contentImages: [UIImage?] = []
            for contentIndex in (0..<count) {
                contentImages.append(images[imageIndex + contentIndex])
            }
            for (contentViewIndex, contentView) in frameView.contentViews.enumerated() where contentViewIndex < contentImages.count {
                if let image = contentImages[contentViewIndex] {
                    viewModel.cachedImages[contentView.id] = [image, image]
                }
            }
            frameView.fillImages(contentImages)
            imageIndex += count
        }
        
    }
    
    private func findContent(point: CGPoint) -> DesignScrolledImage? {
        var frame: TemplateFrame?
        for subview in subviews {
            if let frameView = subview as? TemplateFrame, frameView.frame.contains(point) {
                frame = frameView
                break
            }
        }
        guard let frameView = frame else {
            targetContent.isHidden = true
            return nil
        }
        let pointInFrame = self.convert(point, to: frameView)
        for contentView in frameView.contentViews {
            if contentView.frame.contains(pointInFrame) {
                targetContent.isHidden = false
                let center = frameView.convert(contentView.center, to: self)
                targetContent.frame = contentView.frame
                targetContent.center = center
                return contentView
            }
        }
        targetContent.isHidden = true
        return nil
    }
    
    private func buildBoundViewContent() {
        boundsView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30,
                                   height: 30))
            $0.top.trailing.equalToSuperview()
        }
        deleteButton.isHidden = true
        deleteButton.addTarget(self,
                              action: #selector(reset),
                              for: .primaryActionTriggered)
    }
    
    private func drawFrames(frames: [FrameTemplateViewModel], ratioStandard: CGFloat) {
        // vi khi set frame o createDesignViewController chung ta padding + 10
        let extraSpace: CGFloat = 0
        let ratioDesign = (bounds.width - extraSpace) / (bounds.height - extraSpace)
        var designHeight = bounds.height - extraSpace
        var designWidth = designHeight * ratioStandard
        if ratioStandard <= ratioDesign {
            designWidth = bounds.width - extraSpace
            designHeight = designWidth / ratioStandard
        }
        let center = CGPoint(x: bounds.width / 2,
                             y: bounds.height / 2)
        [backgroundImageView, maskImageView].forEach {
            $0.frame = CGRect(origin: .zero,
                              size: CGSize(width: designWidth,
                                           height: designHeight))
            $0.center = center
        }
        let offsetX = (bounds.width - designWidth) / 2
        let offsetY = (bounds.height - designHeight) / 2
        let frameExtraSpace: CGFloat = 2
        
        guard viewModel.changeWithNewTemplate.value else {
            for (index, frame) in frames.enumerated() {
                let height = designHeight * frame.model.scaleH
                let width = height * frame.model.ratio
                let centerX = designWidth * frame.model.scaleX
                let centerY = designHeight * frame.model.scaleY

                let rect = CGRect(origin: .zero,
                                  size: CGSize(width: width + frameExtraSpace,
                                               height: height + frameExtraSpace))
                let frameView = self.frameViews[index]
                frameView.transform = .identity
                frameView.frame = rect
                frameView.center = CGPoint(x: centerX + offsetX,
                                           y: centerY + offsetY)
                frameView.transform = frameView.transform.rotated(by: .pi * frame.model.angle / 180)
                // update layout contents in frameView
                frameView.updateContentsLayout(frameSize: rect.size,
                                               contents: frame.model.contents)
                for contentView in frameView.contentViews {
                    if let images = viewModel.cachedImages[contentView.id] {
                        contentView.addImage(images[0])
                        contentView.originalImage = images[1]
                    }
                }
            }
            return
        }
        
        let cachedImages = Array(viewModel.cachedImages.values)
        viewModel.cachedImages.removeAll()
        var imagesIndex = 0
        subviews.forEach {
            if $0 as? TemplateFrame != nil {
                $0.removeFromSuperview()
            }
        }
        frameViews.removeAll()
        for frame in frames {
            let height = designHeight * frame.model.scaleH
            let width = height * frame.model.ratio
            let centerX = designWidth * frame.model.scaleX
            let centerY = designHeight * frame.model.scaleY
            let rect = CGRect(origin: .zero,
                              size: CGSize(width: width + frameExtraSpace,
                                           height: height + frameExtraSpace))
            let frameView = TemplateFrame(maskImage: frame.model.mask,
                                          backgroundImage: frame.model.background,
                                          frameSize: rect.size,
                                          contents: frame.model.contents,
                                          onTop: frame.model.onTop == 1)
            self.frameViews.append(frameView)
            addSubview(frameView)
            frameView.frame = rect
            frameView.center = CGPoint(x: centerX + offsetX,
                                       y: centerY + offsetY)
            frameView.transform = frameView.transform.rotated(by: .pi * frame.model.angle / 180)
            
            for (contentIndex, contentView) in frameView.contentViews.enumerated() {
                contentView.addButton.reactive.pressed = CocoaAction(viewModel.selectFrameAction) { [weak self, frame, frameView, contentView] _ in
                    guard let sself = self else { return nil }
                    if sself.selectedFrameView != frameView {
                        frameView.selectedContent = contentView
                        self?.boundSelectedContent(contentView: contentView,
                                                   angle: frame.model.angle)
                        self?.selectedFrameView = frameView
                        frame.originalImage.swap(nil)
                        frame.image.swap(nil)
                        frame.selectedContentId = contentView.id
                        return frame
                    }
                    sself.selectedFrameView = nil
                    sself.boundsView.isHidden = true
                    return nil
                }
                contentView.tapRecognizer.reactive.stateChanged.filter { $0.state == .ended }.observeValues { [weak self, frame, frameView, contentView] _ in
                    guard let sself = self else { return }
                    if sself.selectedFrameView != frameView {
                        sself.selectedFrameView = frameView
                        // update original image from selected content
                        frame.originalImage.swap(contentView.originalImage)
                        frame.image.swap(contentView.designedImageView.image)
                        sself.viewModel.selectedFrame.swap(frame)
                        frame.selectedContentId = contentView.id
                        frameView.selectedContent = contentView
                        sself.boundSelectedContent(contentView: contentView,
                                                   angle: frame.model.angle)
                    } else {
                        sself.viewModel.selectedFrame.swap(nil)
                        sself.selectedFrameView = nil
                        sself.boundsView.isHidden = true
                    }
                }
                contentView.longPressRecognizer.reactive.stateChanged.observeValues { [weak self, frameView, contentView] in
                    guard let sself = self, $0.view != nil else { return }
                    switch $0.state {
                    case .began:
                        if contentView.hasImage {
                            sself.copiedContent.isHidden = false
                            sself.copiedContent.image = contentView.designedImageView.image
                            let center = frameView.convert(contentView.center, to: self)
                            sself.copiedContent.frame = contentView.frame
                            sself.copiedContent.center = center
                            sself.copiedContent.originalImage = contentView.originalImage
                        }
                    case .changed:
                        if !sself.copiedContent.isHidden {
                            let touchLocation = $0.location(in: self)
                            sself.copiedContent.center = CGPoint(x: sself.copiedContent.center.x + touchLocation.x - sself.copiedContent.center.x,
                                                                 y: sself.copiedContent.center.y + touchLocation.y - sself.copiedContent.center.y)
                            _ = sself.findContent(point: touchLocation)
                        }
                    case .ended:
                        if !sself.copiedContent.isHidden {
                            let touchLocation = $0.location(in: self)
                            guard let content = sself.findContent(point: touchLocation) else {
                                sself.copiedContent.isHidden = true
                                return
                            }
                            let copiedImage = sself.copiedContent.image
                            let copiedOriginalImage = sself.copiedContent.originalImage
                            
                            if content.designedImageView.image == nil {
                                contentView.addImage(nil)
                                contentView.originalImage = nil
                            } else {
                                contentView.addImage(content.designedImageView.image)
                                contentView.originalImage = content.originalImage
                            }
                            
                            content.addImage(copiedImage)
                            content.originalImage = copiedOriginalImage
                            sself.viewModel.cachedImages[contentView.id] = [contentView.designedImageView.image, contentView.originalImage]
                            sself.viewModel.cachedImages[content.id] = [copiedImage, copiedOriginalImage]
                        }
                        sself.copiedContent.isHidden = true
                        sself.targetContent.isHidden = true
                    default:
                        sself.copiedContent.isHidden = true
                        sself.targetContent.isHidden = true
                    }
                }
                if imagesIndex + contentIndex < cachedImages.count {
                    let images = cachedImages[imagesIndex + contentIndex]
                    viewModel.cachedImages[contentView.id] = images
                    contentView.addImage(images[0])
                    contentView.originalImage = images[1]
                }
            }
            imagesIndex += frameView.contentViews.count
            frameView.reactive.image <~ frame.image
            frameView.reactive.originalImage <~ frame.originalImage
            frameView.reactive.flip <~ frame.flip
            frameView.reactive.rotate <~ frame.rotate
            frameView.reactive.background <~ frame.backgroundImage
            frameView.reactive.mask <~ frame.maskImage
            frame.rotate.signal.observeValues { [frame, viewModel] in
                // rotato original image
                if let image = frame.originalImage.value {
                    let rotatedImage = image.rotate(radians: .pi / 2)
                    frame.originalImage.swap(rotatedImage)
                    viewModel.currentImage.swap(rotatedImage)
                }
            }
        }
        bringSubviewToFront(maskImageView)
        subviews.forEach {
            if let templateFrame = $0 as? TemplateFrame, templateFrame.onTop {
                bringSubviewToFront(templateFrame)
            }
        }
        bringSubviewToFront(targetContent)
        bringSubviewToFront(copiedContent)
        bringSubviewToFront(boundsView)
    }
    
    private func boundSelectedContent(contentView: DesignScrolledImage, angle: CGFloat = 0) {
        guard let contentSuperView = contentView.superview else { return }
        boundsView.transform = .identity
        let center = contentSuperView.convert(contentView.center, to: self)
        boundsView.frame = contentView.bounds.insetBy(dx: 1, dy: 1)
        boundsView.center = center
        boundsView.isHidden = false
        deleteButton.isHidden = !contentView.hasImage
        boundsView.transform = boundsView.transform.rotated(by: .pi * angle / 180)
    }
    
    private func checkShouldAdjustDesign(contentView: DesignScrolledImage) {
        guard let contentSuperView = contentView.superview else { return }
        let center = contentSuperView.convert(contentView.center, to: nil)
        var bottomSpace: CGFloat = 0
        if #available(iOS 11.0, *) {
            guard let superView = superview else {
                return
            }
            bottomSpace = superView.safeAreaInsets.bottom
        }
        // 240 là chiều cao của image selection
        viewModel.shouldAdjustDesign.swap(center.y > UIScreen.main.bounds.height - 240 - bottomSpace)
    }

    @objc func reset() {
        viewModel.setImage(nil)
    }
    
    func rotate() {
        viewModel.selectedFrame.value?.rotate.swap(())
    }
    
    func flip() {
        viewModel.selectedFrame.value?.flip.swap(())
    }
    
    func deselect() {
        boundsView.isHidden = true
        selectedFrameView = nil
    }
    
    func fillResources(resources: [UIImage?]) {
        if resources.count >= 2 {
            let frameLayerBackground = resources[0]
            let frameLayerMask = resources[1]
            backgroundImageView.image = frameLayerBackground
            maskImageView.image = frameLayerMask
        }
        guard resources.count > 2 else { return }
        for index in stride(from: 2, to: resources.count, by: 2) {
            let frameBackground = resources[index]
            let frameMask = resources[index+1]
            let frameIndex = index / 2 - 1
            if frameIndex < viewModel.frames.value.count {
                let frameModel = viewModel.frames.value[frameIndex]
                frameModel.backgroundImage.swap(frameBackground)
                frameModel.maskImage.swap(frameMask)
            }
        }
    }
    
    func createFrameLayerModel() -> FrameLayerModel? {
        // create frame model
        var frameModels: [FrameModel] = []
        for (index, frame) in viewModel.frames.value.enumerated() {
            let frameView = frameViews[index]
            let onTop: Int = frame.model.onTop
            let centerX: CGFloat = frameView.center.x
            let centerY: CGFloat = frameView.center.y
            let width: CGFloat = frameView.frame.width
            let height: CGFloat = frameView.frame.height
            let parentWidth: CGFloat = self.frame.width
            let parentHeight: CGFloat = self.frame.height
            let angle: CGFloat = frame.model.angle
            
            let background: String? = frame.model.background
            let mask: String? = frame.model.mask
            
            var contents: [FrameModel.Content] = []
            for (contentIndex, contentView) in frameView.contentViews.enumerated() {
                let centerX: CGFloat = contentView.center.x
                let centerY: CGFloat = contentView.center.y
                let width: CGFloat = contentView.frame.width
                let height: CGFloat = contentView.frame.height
                let parentWidth: CGFloat = frameView.frame.width
                let parentHeight: CGFloat = frameView.frame.height
                let angle: CGFloat = frame.model.contents[contentIndex].angle
                var originalImageData: Data?
                var imageData: Data?
                if let image = contentView.designedImageView.image {
                    imageData = image.pngData()
                    originalImageData = contentView.originalImage?.pngData()
                }
                let content = FrameModel.Content(centerX: centerX,
                                                 centerY: centerY,
                                                 width: width,
                                                 height: height,
                                                 parentWidth: parentWidth,
                                                 parentHeight: parentHeight,
                                                 angle: angle,
                                                 originalImageData: originalImageData,
                                                 imageData: imageData)
                contents.append(content)
            }
            
            let frameModel = FrameModel(onTop: onTop,
                                        centerX: centerX,
                                        centerY: centerY,
                                        width: width,
                                        height: height,
                                        parentWidth: parentWidth,
                                        parentHeight: parentHeight,
                                        angle: angle,
                                        background: background,
                                        mask: mask,
                                        contents: contents)
            frameModels.append(frameModel)
        }
        guard let frameLayerModel = viewModel.frameLayerModel.value  else {
            return nil
        }
        let composedFrameLayerModel = FrameLayerModel(background: frameLayerModel.background,
                                                      mask: frameLayerModel.mask,
                                                      color: frameLayerModel.color,
                                                      width: self.frame.width,
                                                      height: self.frame.height,
                                                      frames: frameModels)
        return composedFrameLayerModel
    }
}

extension Reactive where Base: FrameTemplateLayer {
    var reset: BindingTarget<Void> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.reset()
        }
    }
    var rotate: BindingTarget<Void> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.rotate()
        }
    }
    var flip: BindingTarget<Void> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.flip()
        }
    }
    var deselect: BindingTarget<Void> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.deselect()
        }
    }
}
