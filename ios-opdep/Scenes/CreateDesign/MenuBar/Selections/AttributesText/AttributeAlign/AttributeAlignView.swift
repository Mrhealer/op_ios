//
//  AttributeAlignView.swift
//  OPOS
//
//  Created by Nguyễn Quang on 10/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class AttributeAlignView: UIView {

    let viewModel: AttributeAlignViewModel
    let containerView: UIView = {
        let view = UIView()
        return view
    }()

    let buttonAlignLeft = StyleButton(image: R.image.text_align_left())
    let buttonAlignRight = StyleButton(image: R.image.text_align_right())
    let buttonAlignCenter = StyleButton(image: R.image.text_align())
    
    let buttonUpperCased = StyleButton(image: R.image.text_uppercase())
    let buttonLowerCased = StyleButton(image: R.image.text_lowercased())
    let buttonCapitalized = StyleButton(image: R.image.text_capitalized())
    
    let shadowSlider: SettingSlider

    init(viewModel: AttributeAlignViewModel) {
        self.viewModel = viewModel
        shadowSlider = .init(viewModel: viewModel.settingSliderViewModel)
        super.init(frame: .zero)
        prepare()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        reactive.isHidden <~ viewModel.isSelected.negate()
        let separator = UIView()
        let separatorBottom = UIView()
        separator.backgroundColor = .gray
        separatorBottom.backgroundColor = .gray
        let stackSpec = StackSpec(axis: .horizontal,
                                  distribution: .fillEqually,
                                  alignment: .leading,
                                  spacing: 10)
        let stackSpecCased = StackSpec(axis: .horizontal,
                                       distribution: .fillEqually,
                                       alignment: .leading,
                                       spacing: 10)
        stackSpec.add(buttonAlignLeft, buttonAlignCenter, buttonAlignRight)
        stackSpecCased.add(buttonUpperCased, buttonCapitalized, buttonLowerCased)
        let stackView = stackSpec.build()
        let stackViewCased = stackSpecCased.build()
        
        addSubviews(containerView)
        containerView.addSubviews(stackView, separator,
                                  stackViewCased, separatorBottom,
                                  shadowSlider)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(44)
        }
        stackViewCased.snp.makeConstraints {
            $0.right.top.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(44)
        }
        separator.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 35))
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(stackView)
        }
        separatorBottom.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(10)
        }
        shadowSlider.snp.makeConstraints {
            $0.top.equalTo(separatorBottom.snp.bottom).offset(10)
            $0.left.bottom.right.equalToSuperview()
        }
        [buttonAlignLeft, buttonAlignCenter, buttonAlignRight,
         buttonUpperCased, buttonLowerCased, buttonCapitalized].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(44)
            }
        }
        buttonAlignLeft.reactive.pressed = CocoaAction(viewModel.alignAction,
                                                       input: .left)
        buttonAlignCenter.reactive.pressed = CocoaAction(viewModel.alignAction,
                                                         input: .center)
        buttonAlignRight.reactive.pressed = CocoaAction(viewModel.alignAction,
                                                        input: .right)
        buttonCapitalized.reactive.pressed = CocoaAction(viewModel.selectedTextCasedAction,
                                                         input: TextCased.capitalized)
        buttonLowerCased.reactive.pressed = CocoaAction(viewModel.selectedTextCasedAction,
                                                        input: TextCased.lowerCased)
        buttonUpperCased.reactive.pressed = CocoaAction(viewModel.selectedTextCasedAction,
                                                        input: TextCased.upperCased)
    }
}
