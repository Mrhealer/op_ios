//
//  StyleFrame.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/27/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class StyleFrame: UIView {
    let content: DesignScrolledImage
    let maskImageView = UIImageView()
    
    override init(frame: CGRect) {
        content = .init(frame: CGRect(origin: .zero,
                                      size: frame.size))
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        addSubviews(content, maskImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [content, maskImageView].forEach {
            $0.frame = bounds
        }
        if !content.hasImage { content.drawBorder(isHidden: false) } else {
            content.drawBorder(isHidden: true)
        }
    }
}

extension Reactive where Base: StyleFrame {
    var image: BindingTarget<UIImage?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            base.content.addImage(value)
        }
    }
    
    var deleteImage: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.content.designedImageView.image = nil
        }
    }
    
    var flip: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.content.flip()
        }
    }
    
    var rotate: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
           base.content.rotate()
        }
    }
    
    var mask: BindingTarget<UIImage?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            base.maskImageView.image = value
            guard value != nil else {
                base.content.showAddButton()
                return
            }
            base.content.hideAddButton()
        }
    }
}
