//
//  SettingSlider.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/26/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class SettingSlider: UIView {
    let leftIcon = UIButton()
    let rightIcon = UIButton()
    let slider = UISlider()
    let viewModel: SettingSliderViewModel
    
    init(viewModel: SettingSliderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        let stackSpec = StackSpec(axis: .horizontal,
                                  spacing: 16,
                                  contentInsets: UIEdgeInsets(top: 0,
                                                              left: 16,
                                                              bottom: 0,
                                                              right: 16))
        stackSpec.add(leftIcon, slider, rightIcon)
        let stackView  = stackSpec.build()
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [leftIcon, rightIcon].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(40)
            }
        }
        
        slider.isContinuous = true
        slider.tintColor = .init(hexString: "#D07A00")
        slider.reactive.minimumValue <~ viewModel.model.producer.map { $0.type.minValue }
        slider.reactive.maximumValue <~ viewModel.model.producer.map { $0.type.maxValue }
        slider.reactive.value <~ viewModel.model.producer.map { $0.value }
        viewModel.value <~ slider.reactive.mapControlEvents(.valueChanged) { $0.value }
            .map { [viewModel] in
                SettingSliderModel(value: $0, type: viewModel.model.value.type) }
        leftIcon.reactive.image(for: .normal) <~ viewModel.model.producer.map { $0.type.image }
        rightIcon.reactive.image(for: .normal) <~ viewModel.model.producer.map { _ in nil }
        
        reactive.isHidden <~ viewModel.isSelected.negate()
    }
}
