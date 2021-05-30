//
//  StickerLayer.swift
//  OPOS
//
//  Created by Tran Van Dinh on 10/22/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class StickerLayer: ContainerLayerCommon<ImageTransformable> {
    let viewModel: StickerLayerViewModel
    init(viewModel: StickerLayerViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(designSize: AppConstants.CreateDesign.designImageSize,
                   frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        viewModel.pickedImage.signal.skipNil().observeValues { [weak self] in
            self?.add(image: $0)
        }
        reactive.deselect <~ viewModel.deselect
        reactive.imageUrl <~ viewModel.imageUrl
    }
    
    func add(url: URL) {
        let imageTransform = ImageTransformable(url: url)
        let tapped = UITapGestureRecognizer(target: self,
                                                  action: #selector(tapped(_:)))
        tapped.numberOfTapsRequired = 1
        imageTransform.addGestureRecognizer(tapped)
        add(design: imageTransform)
    }
    
    func add(image: UIImage?) {
        guard let image = image else { return }
        let imageTransform = ImageTransformable(image: image)
        let tapped = UITapGestureRecognizer(target: self,
                                                  action: #selector(tapped(_:)))
        tapped.numberOfTapsRequired = 1
        imageTransform.addGestureRecognizer(tapped)
        add(design: imageTransform)
    }
    
    override func layout(with design: ImageTransformable) {
        design.center = CGPoint(x: frame.width / 2,
                                y: frame.height / 2)
    }
    
    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        guard let image = gesture.view as? ImageTransformable else {
            return
        }
        viewModel.selectedNewSticker.swap(true)
        selected(design: image)
        bringSubviewToFront(image)
    }
    
    func deselect() {
        configureSelectedView(selected: false)
    }
}

extension Reactive where Base: StickerLayer {
    var imageUrl: BindingTarget<URL?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let url = value else { return }
            base.add(url: url)
        }
    }
    
    var deselect: BindingTarget<Void> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.deselect()
        }
    }
}
