//
//  DesignImages.swift
//  OPOS
//
//  Created by Tran Van Dinh on 5/27/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit
import ReactiveSwift

class DesignSingleImage: DesignView<UIImageView> {
    init(designSize: CGSize?) {
        super.init(isContainMultipleDesign: false,
                   designSize: designSize)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        add(design: imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: DesignSingleImage {
    var imageUrl: BindingTarget<URL?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let url = value else { return }
            base.selectedView?.af.setImage(withURL: url)
        }
    }
    
    var imageColor: BindingTarget<UIColor?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let color = value else { return }
            base.selectedView?.backgroundColor = color
            base.selectedView?.image = nil
        }
    }
    
    var deleteImage: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.selectedView?.image = nil
        }
    }
}
