//
//  AttributeTextViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/5/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class AttributeTextViewModel {
    let showedKeyboard = MutableProperty<Bool>(false)
    let doneAction: Action<Void, Bool, Never>
    
    let isSelected = MutableProperty<Bool>(false)
    let menuBarViewModel: AttributesMenuBarViewModel
    
    // Attributes
    let attributeFontViewModel: AttributeFontViewModel
    let colorSelectionViewModel: ColorSelectionViewModel
    let attributeAlignViewModel: AttributeAlignViewModel
    let settingSliderViewModel: SettingSliderViewModel
    
    //output to binding Text layer
    let fontSizeValue = MutableProperty<Float>(16)
    let interlineValue = MutableProperty<Float>(0)
    let distanceValue = MutableProperty<Float>(0)
    let shadowValue = MutableProperty<Float>(0)
    var selectedColor: MutableProperty<ColorModel?> { colorSelectionViewModel.selectedColor }
    var selectedFont: Signal<DesignImageModel?, Never> { attributeFontViewModel.selectedFont.signal }
    var selectedAlign: MutableProperty<NSTextAlignment> { attributeAlignViewModel.selectedAlign }
    var selectedTextCased: MutableProperty<TextCased?> { attributeAlignViewModel.selectedTextCased }
    
    // Show slider with attribute value and type
    let tapFontSizeAction: Action<SliderType, SettingSliderModel, Never>
    let tapInterlineAction: Action<SliderType, SettingSliderModel, Never>
    let tapDistanceAction: Action<SliderType, SettingSliderModel, Never>
    let tapShadowAction: Action<SliderType, SettingSliderModel, Never>
    
    init(apiService: APIService) {
        menuBarViewModel = .init(itemsForDisplay: 4,
                                 backgroundColor: UIColor.Editor.bgMenuSelection)
        
        attributeFontViewModel = .init(apiService: apiService)
        settingSliderViewModel = .init(value: 0,
                                       type: .interline)
        colorSelectionViewModel = .init()
        attributeAlignViewModel = .init()
        tapFontSizeAction = Action(state: fontSizeValue) { value, type in
            .init(value: .init(value: value,
                               type: type))
        }
        
        tapInterlineAction = Action(state: interlineValue) { value, type in
            .init(value: .init(value: value,
                               type: type))
        }
        
        tapDistanceAction = Action(state: distanceValue) { value, type in
            .init(value: .init(value: value,
                               type: type))
        }
        
        tapShadowAction = Action(state: shadowValue) { value, type in
            .init(value: .init(value: value,
                               type: type))
        }
        
        doneAction = Action(state: showedKeyboard) { return .init(value: $0) }
        
        //binding
        // show detail attribute
        attributeFontViewModel.isSelected <~ menuBarViewModel.selectedAttribute.producer.skipNil().map {
            $0.attribute == .font
        }
        colorSelectionViewModel.isSelected <~ menuBarViewModel.selectedAttribute.producer.skipNil().map {
            $0.attribute == .color
        }
        attributeAlignViewModel.isSelected <~ menuBarViewModel.selectedAttribute.producer.skipNil().map {
            $0.attribute == .align
        }
        settingSliderViewModel.isSelected <~ menuBarViewModel.selectedAttribute.producer.skipNil().map {
            !($0.attribute == .font || $0.attribute == .color || $0.attribute == .align)
        }
        // get value from slider
        interlineValue <~ settingSliderViewModel.value.producer
            .skipNil()
            .filter { $0.type == .interline }
            .map { $0.value }
        
        fontSizeValue <~ settingSliderViewModel.value.producer
            .skipNil()
            .filter { $0.type == .fontSize }
            .map { $0.value }
        
        distanceValue <~ settingSliderViewModel.value.producer
            .skipNil()
            .filter { $0.type == .distance }
            .map { $0.value }
            
        shadowValue <~ attributeAlignViewModel.settingSliderViewModel.value.producer
            .skipNil()
            .filter { $0.type == .shadow }
            .map { $0.value }
        // when tap from menu, process data and show slider
        tapFontSizeAction <~ menuBarViewModel.selectedAttribute.producer
            .skipNil()
            .filter { $0.attribute == .fontSize }
            .map { _ in SliderType.fontSize }
        
        tapInterlineAction <~ menuBarViewModel.selectedAttribute.producer
            .skipNil()
            .filter { $0.attribute == .interline }
            .map { _ in SliderType.interline }
        
        tapDistanceAction <~ menuBarViewModel.selectedAttribute.producer
            .skipNil()
            .filter { $0.attribute == .distance }
            .map { _ in SliderType.distance }
        
        tapShadowAction <~ menuBarViewModel.selectedAttribute.producer
            .skipNil()
            .filter { $0.attribute == .align }
            .map { _ in SliderType.shadow }
        
        // update when change tab
        settingSliderViewModel.model <~ Signal.merge(tapInterlineAction.values,
                                                     tapDistanceAction.values,
                                                     tapFontSizeAction.values)
        attributeAlignViewModel.settingSliderViewModel.model <~ tapShadowAction.values
        
        showedKeyboard <~ Signal.merge(isSelected.signal.filter { $0 == true },
                                       doneAction.values.filter { $0 == true }.negate())
    }
    
    func updateWhenChangeText() {
        guard let attribute = menuBarViewModel.selectedAttribute.value else {
            return
        }
        switch attribute.attribute {
        case .fontSize: tapFontSizeAction.apply(.fontSize).start()
        case .interline: tapInterlineAction.apply(.interline).start()
        case .distance: tapDistanceAction.apply(.distance).start()
        case .align: tapShadowAction.apply(.shadow).start()
        default:
            break
        }
    }
}
