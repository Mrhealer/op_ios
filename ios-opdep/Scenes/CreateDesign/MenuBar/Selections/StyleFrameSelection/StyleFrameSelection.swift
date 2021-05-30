//
//  StyleFrameSelection.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/28/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class StyleFrameSelection: PassthroughView {
    let header = PassthroughView()
    let designGridView: GridView<DesignGridViewModel>
    
    let viewModel: StyleFrameSelectionViewModel
    
    init(viewModel: StyleFrameSelectionViewModel) {
        self.viewModel = viewModel
        designGridView = .init(viewModel: viewModel.designGridViewModel)
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        isHidden = true
        let stackSpec = StackSpec(axis: .vertical)
        stackSpec.add(header, designGridView)
        buildHeader()
        let stackView = PassthroughStackView()
        stackView.load(spec: stackSpec)
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        header.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        viewModel.isSelected.signal.observeValues { [weak self] in
            if $0 {
                self?.show()
            } else {
                self?.isHidden = true
            }
        }
    }
    
    private func buildHeader() {
        let hideButton = StyleButton(image: R.image.hidden_selection(),
                                     backgroundColor: .white,
                                     rounded: true)
        let inserImageButton = StyleButton(title: Localize.Editor.editorInsertImage,
                                      titleFont: UIFont.primary(size: 16),
                                      backgroundColor: .white,
                                      rounded: true)
        header.addSubviews(hideButton, inserImageButton)
        
        hideButton.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        inserImageButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 120, height: 32))
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(hideButton.snp.leading).offset(-16)
        }
        
        [inserImageButton, hideButton].forEach {
            $0.withBorder(width: 1,
                          color: .init(hexString: "#000000",
                                       alpha: 0.2))
        }
        
        hideButton.addTarget(self,
                             action: #selector(hide),
                             for: .primaryActionTriggered)
        inserImageButton.reactive.pressed = CocoaAction(viewModel.insertImageAction)
    }
    
    @objc func hide() {
        viewModel.isSelected.swap(false)
    }
    
    private func show() {
        viewModel.fetchFrames()
    }
}
