//
//  ImageEffectsSelection.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/9/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class ImageEffectsSelection: PassthroughView {
    let header = PassthroughView()
    let menuBar: GridView<ImageEffectsMenuBarViewModel>
    
    let effectsContainer = UIView()
    let imageFilterSelection: ImageFilterSelection
    let settingSlider: SettingSlider
    
    let viewModel: ImageEffectsSelectionViewModel
    init(viewModel: ImageEffectsSelectionViewModel) {
        self.viewModel = viewModel
        menuBar = .init(viewModel: viewModel.menuBarViewModel)
        
        settingSlider = .init(viewModel: viewModel.settingSliderViewModel)
        imageFilterSelection = .init(viewModel: viewModel.imageFilterSelectionViewModel)
        
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        isHidden = true
        effectsContainer.backgroundColor = .white
        let stackSpec = StackSpec(axis: .vertical)
        buildHeader()
        stackSpec.add(header, menuBar, effectsContainer)
        effectsContainer.addSubviews(imageFilterSelection, settingSlider)
        let stackView = PassthroughStackView()
        stackView.load(spec: stackSpec)
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let contentInset = UIEdgeInsets(top: 8,
                                        left: 0,
                                        bottom: 0,
                                        right: 0)
        effectsContainer.layoutMargins = contentInset
        [imageFilterSelection, settingSlider].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalTo(effectsContainer.layoutMarginsGuide)
            }
        }
    
        [header, menuBar].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(44)
            }
        }
        
        viewModel.isSelected.signal.observeValues { [weak self] in
            $0 ? self?.show() : self?.hide()
        }
    }
    
    func buildHeader() {
        let hideButton = StyleButton(image: R.image.hidden_selection(),
                                     backgroundColor: .white,
                                     rounded: true)
        header.addSubview(hideButton)
        hideButton.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
        hideButton.withBorder(width: 1,
                              color: .init(hexString: "#000000",
                                           alpha: 0.2))
        hideButton.reactive.pressed = CocoaAction(viewModel.hideAction)
    }
    
    @objc func hide() {
        isHidden = true
    }
    
    func show() {
        viewModel.imageFilterSelectionViewModel.resetSelectedFilter()
        viewModel.menuBarViewModel.didSelectItemAt(indexPath: IndexPath(row: 0,
                                                                        section: 0))
        isHidden = false
    }
}
