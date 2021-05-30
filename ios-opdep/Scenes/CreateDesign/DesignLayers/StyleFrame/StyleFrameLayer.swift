//
//  StyleFrameLayer.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/27/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class StyleFrameLayer: ContainerLayerCommon<FrameTransformable> {
    let viewModel: StyleFrameLayerViewModel
    init(viewModel: StyleFrameLayerViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(isContainMultipleDesign: true,
                   designSize: nil,
                   frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        viewModel.addFrameAction.values.map { $0.0 }.observeValues { [weak self] in
            self?.addFrame(with: $0)
        }
        reactive.reset <~ viewModel.reset
        reactive.rotate <~ viewModel.rotate
        reactive.flip <~ viewModel.flip
        reactive.deselect <~ viewModel.deselect
        
        viewModel.bringFrameToFrontAction.values.observeValues { [weak self] in
            self?.bringFrameToFront(with: $0)
        }
    }
    
    private func bringFrameToFront(with viewModel: StyleFrameViewModel) {
        for subview in subviews {
            if let frameView = subview as? FrameTransformable, frameView.id == viewModel.id {
                bringSubviewToFront(frameView)
                selected(design: frameView)
                break
            }
        }
    }
    
    func addFrame(with frameViewModel: StyleFrameViewModel) {
        let frameView = FrameTransformable(frame: .init(origin: .zero,
                                                    size: AppConstants.CreateDesign.designFrameSize),
                                           id: frameViewModel.id)
        add(design: frameView)
        
        frameView.styleFrame.content.addButton.reactive.pressed = CocoaAction(self.viewModel.selectFrameAction) { [weak self, frameViewModel, frameView] _ in
            if let sself = self {
                sself.selected(design: frameView)
                sself.bringSubviewToFront(frameView)
                sself.viewModel.deleteFrameAction <~ frameView.closeGesture.reactive.stateChanged
                    .filter { $0.state == .ended }
                    .map { _ in frameViewModel.id }
            }
            return frameViewModel
        }
        
        frameView.styleFrame.content.tapRecognizer.reactive.stateChanged.filter { $0.state == .ended }.observeValues { [weak self, frameViewModel, frameView] _ in
            guard let sself = self else { return }
            sself.viewModel.selectedStyleFrame.swap(frameViewModel)
            sself.selected(design: frameView)
            sself.bringSubviewToFront(frameView)
            sself.viewModel.deleteFrameAction <~ frameView.closeGesture.reactive.stateChanged
                .filter { $0.state == .ended }
                .map { _ in frameViewModel.id }
        }
        self.viewModel.deleteFrameAction <~ frameView.closeGesture.reactive.stateChanged
            .filter { $0.state == .ended }
            .map { _ in frameViewModel.id }
        frameView.styleFrame.reactive.image <~ frameViewModel.image
        frameView.styleFrame.reactive.flip <~ frameViewModel.flip
        frameView.styleFrame.reactive.rotate <~ frameViewModel.rotate
        frameView.styleFrame.reactive.mask <~ frameViewModel.maskImage
        frameViewModel.rotate.signal.observeValues { [frameViewModel, viewModel] in
            // rotato original image
            if let image = frameViewModel.originalImage.value {
                let rotatedImage = image.rotate(radians: .pi / 2)
                frameViewModel.originalImage.swap(rotatedImage)
                viewModel.currentImage.swap(rotatedImage)
            }
        }
    }
    
    override func layout(with design: FrameTransformable) {
        design.center = CGPoint(x: frame.width / 2,
                                y: frame.height / 2)
    }
    
    func reset() {
        viewModel.setImage(image: nil)
    }
    
    func rotate() {
        viewModel.selectedStyleFrame.value?.rotate.swap(())
    }
    
    func flip() {
        viewModel.selectedStyleFrame.value?.flip.swap(())
    }
    
    func deselect() {
        configureSelectedView(selected: false)
    }
}

extension Reactive where Base: StyleFrameLayer {
    var deselect: BindingTarget<Void> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.deselect()
        }
    }
    
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
}
