//
//  AttributeText.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/5/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class AttributeText: UIView {
    let header = UIView()
    let textView = UITextView()
    let menuBar: GridView<AttributesMenuBarViewModel>
    
    let attributesContainer = UIView()
    let attributeFont: AttributeFont
    let settingSlider: SettingSlider
    let colorSelection: ColorSelection
    let attributeAlign: AttributeAlignView
    
    let viewModel: AttributeTextViewModel
    init(viewModel: AttributeTextViewModel) {
        self.viewModel = viewModel
        menuBar = .init(viewModel: viewModel.menuBarViewModel)

        attributeFont = .init(viewModel: viewModel.attributeFontViewModel)
        
        settingSlider = .init(viewModel: viewModel.settingSliderViewModel)
        
        colorSelection = .init(viewModel: viewModel.colorSelectionViewModel)
        
        attributeAlign = .init(viewModel: viewModel.attributeAlignViewModel)
        
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        isHidden = true
        backgroundColor = .white
        textView.font = UIFont.primary(size: 16)
        textView.inputAccessoryView = buildAccessoryViewKeyBoard()
        let containerMenuBar = UIView()
        containerMenuBar.backgroundColor = .white
        menuBar.layer.cornerRadius = 22
        menuBar.layer.masksToBounds = true
        
        let stackSpec = StackSpec(axis: .vertical)
        buildHeader()
        stackSpec.add(header, containerMenuBar, attributesContainer)
        containerMenuBar.addSubview(menuBar)
        attributesContainer.addSubviews(attributeFont, settingSlider, colorSelection, attributeAlign)
        let stackView = stackSpec.build()
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let contentInset = UIEdgeInsets(top: 8,
                                        left: 0,
                                        bottom: 0,
                                        right: 0)
        attributesContainer.layoutMargins = contentInset
        [attributeFont, settingSlider, colorSelection, attributeAlign].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalTo(attributesContainer.layoutMarginsGuide)
            }
        }
    
        header.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        containerMenuBar.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        menuBar.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        reactive.isHidden <~ Signal.merge(viewModel.doneAction.values.negate(),
                                          viewModel.isSelected.signal.negate())
        textView.reactive.resignFirstResponder <~ Signal.merge(viewModel.doneAction.values
        .filter { $0 == true }
            .map { _ in },
                                                               viewModel.isSelected.signal
                                                                .filter { $0 == false }
                                                                .map { _ in })
        textView.reactive.becomeFirstResponder <~ viewModel.isSelected.signal
            .filter { $0 == true }
            .map { _ in }
    }
    
    func buildHeader() {
        header.backgroundColor = .white
        header.whiteShadow()
        textView.backgroundColor = .white
        textView.textColor = .blue
        let buttonShowKeyBoard = StyleButton(image: R.image.keyboard())
        let doneButton = StyleButton(image: R.image.confirm_icon())
        let labelTitle = StyleLabel(text: Localize.Editor.attributeText,
                                    font: .font(style: .medium, size: 14),
                                    textAlignment: .center)
        header.addSubviews(textView, doneButton, buttonShowKeyBoard, labelTitle)
        buttonShowKeyBoard.snp.makeConstraints {
            $0.width.height.equalTo(25)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        }
        doneButton.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        labelTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(buttonShowKeyBoard.snp.right)
            $0.right.equalTo(doneButton.snp.left)
        }
        doneButton.reactive.pressed = CocoaAction(viewModel.doneAction)
        buttonShowKeyBoard.addTarget(self, action: #selector(showKeyboard), for: .touchUpInside)
    }
    
    func buildAccessoryViewKeyBoard() -> UIView {
        let container = UIView(frame:CGRect(x: 0, y: 0,
                                            width: UIScreen.main.bounds.width, height: 45))
        container.whiteShadow()
        container.backgroundColor = .white
        let buttonEditText = StyleButton(image: R.image.edit_text_icon())
        let labelEditText = StyleLabel(text: Localize.Editor.attributeText,
                                       font: .font(style: .regular, size: 14))
        container.addSubviews(buttonEditText, labelEditText)
        buttonEditText.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        }
        labelEditText.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(buttonEditText.snp.right).offset(6)
        }
        buttonEditText.addTarget(self, action: #selector(doneKeyBoard), for: .touchUpInside)
        container.sizeToFit()
        return container
    }
    
    @objc func doneKeyBoard() {
        viewModel.doneAction.apply().start()
    }
    
    @objc func showKeyboard() {
        viewModel.isSelected.swap(true)
    }
}
