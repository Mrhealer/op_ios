//
//  ContainerLayerCommon.swift
//  OPOS
//
//  Created by longbp on 8/22/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

class ContainerLayerCommon<T: BaseView>: PassthroughView, UIGestureRecognizerDelegate {
    private let isContainMultipleDesign: Bool
    let designSize: CGSize?
    var selectedView: T?
    
    init(isContainMultipleDesign: Bool = true,
         designSize: CGSize? = nil,
         frame: CGRect = .zero) {
        self.isContainMultipleDesign = isContainMultipleDesign
        self.designSize = designSize
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Prepare
    func prepare() {}
    
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
            view.showEditingHandlers(status: true)
        } else {
            view.showEditingHandlers(status: false)
            view.setEnableMove(true)
            selectedView = nil
        }
    }
    
    func selected(design: T) {
        guard canAddDesign else { return }
        configureSelectedView(selected: false)
        selectedView = design
        configureSelectedView(selected: true)
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
