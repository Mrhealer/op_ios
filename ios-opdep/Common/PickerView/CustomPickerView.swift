//
//  File.swift
//  OPOS
//
//  Created by Nguyễn Quang on 10/2/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class CustomPickerView: BasicViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let viewModel: CustomPickerViewModel
    let saperatorLineTop = UIView()
    //
    let containerTitle = UIView()
    let buttonCancel = StyleButton(title: "Hủy",
                                   titleFont: .font(style: .medium,
                                                    size: 15),
                                   titleColor: .black)
    let labelTitle = StyleLabel(font: .font(style: .medium, size: 16),
                                textColor: .black,
                                textAlignment: .center)
    let buttonChoose = StyleButton(title: "Chọn",
                                    titleFont: .font(style: .medium,
                                                     size: 15),
                                    titleColor: .black)
    //
    let saperatorLineBottom = UIView()
    
    let pickerView = UIPickerView()
    
    init(viewModel: CustomPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        bindViewModel(viewModel)
        view.backgroundColor = UIColor.Basic.white
        prepare()
        binding()
    }
    
    func prepare() {
        pickerView.delegate = self
        pickerView.dataSource = self
        viewModel.fetchCity()
        viewModel.fetchCityAction.values.observeValues { _ in
            self.pickerView.reloadAllComponents()
        }
        saperatorLineTop.backgroundColor = .gray
        saperatorLineBottom.backgroundColor = .gray

        view.addSubviews(saperatorLineTop,
                         containerTitle,
                         saperatorLineBottom,
                         pickerView)
        
        containerTitle.addSubviews(buttonCancel,
                                   labelTitle,
                                   buttonChoose)
        
        saperatorLineTop.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        containerTitle.snp.makeConstraints {
            $0.top.equalTo(saperatorLineTop.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(46)
        }
        saperatorLineBottom.snp.makeConstraints {
            $0.top.equalTo(containerTitle.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        buttonCancel.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(50)
        }
        buttonChoose.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(50)
        }
        labelTitle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        pickerView.snp.makeConstraints {
            $0.top.equalTo(saperatorLineBottom.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
    func binding() {
        buttonCancel.reactive.pressed = CocoaAction(viewModel.cancelAction)
        buttonChoose.reactive.pressed = CocoaAction(viewModel.chooseAction)
        labelTitle.reactive.text <~ viewModel.title
        pickerView.setValue(UIColor.black, forKey: "textColor")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
            
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.dataPicker.value.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.dataPicker.value[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < viewModel.dataPicker.value.count {
            viewModel.nameSelected.swap(viewModel.dataPicker.value[row].name)
            viewModel.idSelected.swap(viewModel.dataPicker.value[row].id)
        }
    }
}
