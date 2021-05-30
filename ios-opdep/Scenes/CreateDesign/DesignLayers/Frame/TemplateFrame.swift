//
//  TemplateFrame.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/18/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class TemplateFrame: UIView {
    let onTop: Bool
    var selectedContent: DesignScrolledImage?
    var contentViews: [DesignScrolledImage] = []
    let maskImageView = UIImageView()
    let backgroundImageView = UIImageView()
    init(maskImage: String?,
         backgroundImage: String?,
         frameSize: CGSize,
         contents: [FrameModel.Content],
         onTop: Bool) {
        self.onTop = onTop
        super.init(frame: .zero)
        prepare(maskImage: maskImage,
                backgroundImage: backgroundImage,
                frameSize: frameSize,
                contents: contents)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare(maskImage: String?,
                 backgroundImage: String?,
                 frameSize: CGSize,
                 contents: [FrameModel.Content]) {
        addSubviews(backgroundImageView, maskImageView)
        [backgroundImageView, maskImageView].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.contentMode = .scaleAspectFill
        }
        drawContents(frameSize: frameSize,
                     contents: contents)
    }
    
    func fillImages(_ images: [UIImage?]) {
        for (index, contentView) in self.contentViews.enumerated() where index < images.count {
            let image = images[index]
            contentView.addImage(image)
            contentView.originalImage = image
        }
    }
    
    private func drawContents(frameSize: CGSize, contents: [FrameModel.Content]) {
        for content in contents {
            let contentHeight = content.scaleH * frameSize.height
            let contentWidth = content.ratio * contentHeight
            let contentCenterX = content.scaleX * frameSize.width
            let contentCenterY = content.scaleY * frameSize.height
            let scrolledImage = DesignScrolledImage(frame: CGRect(origin: .zero,
                                                size: CGSize(width: contentWidth,
                                                             height: contentHeight)),
                                                    extraSpace: 2)
            scrolledImage.center = CGPoint(x: contentCenterX,
                                           y: contentCenterY)
            addSubview(scrolledImage)
            contentViews.append(scrolledImage)
            if let imageData = content.imageData {
                let image = UIImage(data: imageData)
                scrolledImage.addImage(image)
                if let originalImageData = content.originalImageData {
                    scrolledImage.originalImage = UIImage(data: originalImageData)
                }
            }
        }
        bringSubviewToFront(maskImageView)
    }
    
    func updateContentsLayout(frameSize: CGSize, contents: [FrameModel.Content]) {
        for (index, content) in contents.enumerated() {
            let scrolledImage = contentViews[index]
            let contentHeight = content.scaleH * frameSize.height
            let contentWidth = content.ratio * contentHeight
            let contentCenterX = content.scaleX * frameSize.width
            let contentCenterY = content.scaleY * frameSize.height
            scrolledImage.frame = CGRect(origin: .zero,
                                         size: CGSize(width: contentWidth,
                                                      height: contentHeight))
            scrolledImage.center = CGPoint(x: contentCenterX,
                                           y: contentCenterY)
            contentViews.append(scrolledImage)
        }
        bringSubviewToFront(maskImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in subviews {
            if let scrolledImage = subview as? DesignScrolledImage {
                if !scrolledImage.hasImage {
                    scrolledImage.drawBorder(isHidden: false)
                } else {
                    scrolledImage.drawBorder(isHidden: true)
                }
            }
        }
    }
}

extension Reactive where Base: TemplateFrame {
    var image: BindingTarget<UIImage?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let selectedContent = base.selectedContent else { return }
            selectedContent.addImage(value)
        }
    }
    
    var originalImage: BindingTarget<UIImage?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let selectedContent = base.selectedContent else { return }
            selectedContent.originalImage = value
        }
    }
    
    var deleteImage: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            guard let selectedContent = base.selectedContent else { return }
            selectedContent.designedImageView.image = nil
        }
    }
    
    var flip: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            guard let selectedContent = base.selectedContent else { return }
            selectedContent.flip()
        }
    }
    
    var rotate: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
           guard let selectedContent = base.selectedContent else { return }
           selectedContent.rotate()
        }
    }
    
    var background: BindingTarget<UIImage?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            base.backgroundImageView.image = value
        }
    }
    
    var mask: BindingTarget<UIImage?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            base.maskImageView.image = value
        }
    }
}
