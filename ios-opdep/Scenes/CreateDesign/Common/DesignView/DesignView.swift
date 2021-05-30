//
//  DesignView.swift
//  OPOS
//
//  Created by Tran Van Dinh on 5/25/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

class DesignView<T: UIView>: UIView, UIGestureRecognizerDelegate {
    private let isContainMultipleDesign: Bool
    let minScale: CGFloat
    let maxScale: CGFloat
    
    let designSize: CGSize?
    
    var selectedView: T?
    private var oldLocation: CGPoint = .zero
    
    private let centerXLineView = UIView()
    private let centerYLineView = UIView()
    
    var enable: Bool {
        get { isUserInteractionEnabled }
        set { isUserInteractionEnabled = newValue }
    }
    
    init(minScale: CGFloat = AppConstants.CreateDesign.minZoom,
         maxScale: CGFloat = AppConstants.CreateDesign.imageMaxZoom,
         isContainMultipleDesign: Bool = true,
         designSize: CGSize? = nil) {
        self.minScale = minScale
        self.maxScale = maxScale
        self.isContainMultipleDesign = isContainMultipleDesign
        self.designSize = designSize
        super.init(frame: .zero)
        prepare()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Prepare
    func prepare() {
        addSubview(centerXLineView)
        addSubview(centerYLineView)
        centerXLineView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(1)
            $0.center.equalToSuperview()
        }
        centerYLineView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
            $0.center.equalToSuperview()
        }
        // NNQ
//        centerXLineView.backgroundColor = UIColor.Background.lightRed
//        centerYLineView.backgroundColor = UIColor.Background.lightRed
        hideCenterLines()
        
        let rotationRecognizer = UIRotationGestureRecognizer(target: self,
                                                             action: #selector(handleRotation(_:)))
        addGestureRecognizer(rotationRecognizer)
        rotationRecognizer.delegate = self
        
        let panRecognizer = UIPanGestureRecognizer(target: self,
                                                   action: #selector(handlePan(_:)))
        addGestureRecognizer(panRecognizer)
        panRecognizer.delegate = self
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self,
                                                       action: #selector(handlePinch(_:)))
        addGestureRecognizer(pinchRecognizer)
        pinchRecognizer.delegate = self
    }
    
    // MARK: - Handle Gesture and Touch
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let selectedView = self.selectedView  else { return }
        selectedView.transform = selectedView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let selectedView = self.selectedView  else { return }
        let translation = gesture.translation(in: self)
        var newPosition = CGPoint(x: oldLocation.x + translation.x,
                                  y: oldLocation.y + translation.y)
        if abs(newPosition.x - center.x) <= 2.0 {
            newPosition.x = center.x
        }
        if abs(newPosition.y - center.y) <= 2.0 {
            newPosition.y = center.y
        }
        selectedView.center = newPosition
        switch gesture.state {
        case .began:
            centerXLineView.isHidden = newPosition.x != center.x
            centerYLineView.isHidden = newPosition.y != center.y
        case .changed:
            centerXLineView.isHidden = newPosition.x != center.x
            centerYLineView.isHidden = newPosition.y != center.y
        case .ended:
            hideCenterLines()
        default:
            break
        }
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard gesture.state == .began
            || gesture.state == .changed else { return }
        guard let selectedView = self.selectedView,
            let currentScale = selectedView.layer.value(forKeyPath: "transform.scale.x") as? CGFloat else { return }
        let zoomSpeed: CGFloat = 0.75
        
        var deltaScale: CGFloat = gesture.scale
        deltaScale = ((deltaScale - 1) * zoomSpeed) + 1
        deltaScale = min(deltaScale, maxScale / currentScale)
        deltaScale = max(deltaScale, minScale / currentScale)
        selectedView.transform = selectedView.transform.scaledBy(x: deltaScale,
                                                                 y: deltaScale)
        gesture.scale = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)
        guard bounds.contains(position) else { return }
        configureSelectedView(selected: false)
        var selected = false
        if let view = getSelectedView(with: touch) {
            selectedView = view
            selected = true
        }
        guard let view = selectedView else { return }
        bringSubviewToFront(view)
        configureSelectedView(selected: selected)
        oldLocation = view.center
    }
    
    private func hideCenterLines() {
        centerXLineView.isHidden = true
        centerYLineView.isHidden = true
    }
    
    private func getSelectedView(with touch: UITouch) -> T? {
        var selectedView: T?
        for subview in subviews.reversed() where subview as? T != nil {
            let position = touch.location(in: subview)
            if subview.bounds.contains(position) {
                selectedView = subview as? T
                break
            }
        }
        return selectedView
    }
    
    func configureSelectedView(selected: Bool) {
        guard isContainMultipleDesign, let view = selectedView else { return }
        if selected {
            // NNQ
//            view.withBorder(width: AppConstants.CreateDesign.designBorderWidth,
//                            color: UIColor.CreateDesign.selectedBorder)
            view.withBorder(width: AppConstants.CreateDesign.designBorderWidth,
                            color: .red)
        } else {
            view.withBorder(width: 0.0,
                            color: .clear)
//            selectedView = nil
        }
    }
    
    func add(design: T) {
        guard canAddDesign else { return }
        configureSelectedView(selected: false)
        selectedView = design
        configureSelectedView(selected: true)
        addSubview(design)
        layout(with: design)
    }
    
    private var canAddDesign: Bool {
        if isContainMultipleDesign { return true }
        for subview in subviews where subview as? T != nil {
            return false
        }
        return true
    }
    
    func removeSelectedView() {
        selectedView?.removeFromSuperview()
        selectedView = nil
    }
    
    func layout(with design: T) {
        design.snp.makeConstraints {
            guard let size = designSize else {
                $0.edges.equalToSuperview()
                return
            }
            $0.size.equalTo(size)
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
