//
//  ImageEffectsSelectionViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/9/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class ImageEffectsSelectionViewModel {
    let isSelected = MutableProperty<Bool>(false)
    let imageContext = MutableProperty<ImageContext>(.background)
    let menuBarViewModel: ImageEffectsMenuBarViewModel
    let settingSliderViewModel: SettingSliderViewModel
    let imageFilterSelectionViewModel: ImageFilterSelectionViewModel
    
    let tapSaturationAction: Action<SliderType, SettingSliderModel, Never>
    let tapBrightnessAction: Action<SliderType, SettingSliderModel, Never>
    let tapContrastAction: Action<SliderType, SettingSliderModel, Never>
    
    //output: truyền đi khi giá trị slider or select filter thay đổi
    let saturationContextAction: Action<Float, (Float, ImageContext), Never>
    let brightnessContextAction: Action<Float, (Float, ImageContext), Never>
    let contrastContextAction: Action<Float, (Float, ImageContext), Never>
    let selectFilterAction: Action<ImageFilterModel?, (ImageFilterModel?, ImageContext), Never>
    
    private let saturationValue = MutableProperty<Float>(1)
    private let brightnessValue = MutableProperty<Float>(0)
    private let contrastValue = MutableProperty<Float>(1)
    private var selectedFilter: MutableProperty<ImageFilterModel?> { imageFilterSelectionViewModel.selectedFilter }
    
    let hideAction: Action<Void, Void, Never>
    
    init() {
        saturationContextAction = Action(state: imageContext) { context, input in
            return .init(value: (input, context))
        }
        brightnessContextAction = Action(state: imageContext) { context, input in
            return .init(value: (input, context))
        }
        contrastContextAction = Action(state: imageContext) { context, input in
            return .init(value: (input, context))
        }
        selectFilterAction = Action(state: imageContext) { context, input in
            return .init(value: (input, context))
        }
        menuBarViewModel = .init(itemsForDisplay: 4,
                                 backgroundColor: UIColor.Editor.bgMenuSelection)
        settingSliderViewModel = .init(value: 0,
                                       type: .saturation)
        imageFilterSelectionViewModel = .init()
        
        tapSaturationAction = Action(state: saturationValue) { value, type in
            .init(value: .init(value: value,
                               type: type))
        }
        
        tapBrightnessAction = Action(state: brightnessValue) { value, type in
            .init(value: .init(value: value,
                               type: type))
        }
        
        tapContrastAction = Action(state: contrastValue) { value, type in
            .init(value: .init(value: value,
                               type: type))
        }
        
        hideAction = Action { .init(value: $0) }
        
        saturationValue <~ settingSliderViewModel.value.producer
            .skipNil()
            .filter { $0.type == .saturation }
            .map { $0.value }
        
        brightnessValue <~ settingSliderViewModel.value.producer
            .skipNil()
            .filter { $0.type == .brightness }
            .map { $0.value }
            
        contrastValue <~ settingSliderViewModel.value.producer
            .skipNil()
            .filter { $0.type == .contrast }
            .map { $0.value }
        
        // xác định setting nào được tap
        tapSaturationAction <~ menuBarViewModel.selectedEffect.signal
            .skipNil()
            .filter { $0.effect == .saturation }
            .map { _ in SliderType.saturation }
        
        tapBrightnessAction <~ menuBarViewModel.selectedEffect.signal
            .skipNil()
            .filter { $0.effect == .brightness }
            .map { _ in SliderType.brightness }
        
        tapContrastAction <~ menuBarViewModel.selectedEffect.signal
            .skipNil()
            .filter { $0.effect == .contrast }
            .map { _ in SliderType.contrast }
        
        // truyền dữ liệu vào slider khi tap vào các setting
        settingSliderViewModel.model <~ Signal.merge(tapSaturationAction.values,
                                                     tapBrightnessAction.values,
                                                     tapContrastAction.values)
        
        saturationContextAction <~ saturationValue
        brightnessContextAction <~ brightnessValue
        contrastContextAction <~ contrastValue
        selectFilterAction <~ selectedFilter
        
        settingSliderViewModel.isSelected <~ menuBarViewModel.selectedEffect.producer
            .skipNil()
            .map { $0.effect != .filter }
        
        imageFilterSelectionViewModel.isSelected <~ menuBarViewModel.selectedEffect.producer
            .skipNil()
            .map { $0.effect == .filter }
        
        isSelected <~ hideAction.values.map { _ in false }
    }
}
