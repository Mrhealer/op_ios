//
//  SettingSliderViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/26/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

struct SettingSliderModel {
    let value: Float
    let type: SliderType
}

enum SliderType {
    case saturation
    case brightness
    case contrast
    case roundCorner
    case size
    case format
    case interline
    case distance
    case curve
    case shadow
    case fontSize
    
    var minValue: Float {
        switch self {
        case .saturation: return 0
        case .brightness: return -0.5
        case .contrast: return 0.4
        case .roundCorner: return 0
        case .size: return -0.5
        case .format: return 0
        case .interline: return -10
        case .distance: return -20
        case .curve: return -500
        case .shadow: return -10
        case .fontSize: return 5
        }
    }
    
    var maxValue: Float {
        switch self {
        case .saturation: return 2
        case .brightness: return 0.5
        case .contrast: return 2
        case .roundCorner: return 50
        case .size: return 0.5
        case .format: return 50
        case .interline: return 180
        case .distance: return 20
        case .curve: return 500
        case .shadow: return 10
        case .fontSize: return 100
        }
    }
    
    var image: UIImage? {
        switch self {
        case .saturation: return nil
        case .brightness: return nil
        case .contrast: return nil
        case .roundCorner: return nil
        case .size: return nil
        case .format: return nil
        case .interline: return R.image.text_interline()
        case .distance: return R.image.text_distance()
        case .curve: return nil
        case .shadow: return R.image.text_shadow()
        case .fontSize: return R.image.text_font_size()
        }
    }
}

class SettingSliderViewModel {
    let isSelected = MutableProperty<Bool>(false)
    let model: MutableProperty<SettingSliderModel>
    let value = MutableProperty<SettingSliderModel?>(nil)
    init(value: Float,
         type: SliderType) {
        model = MutableProperty(.init(value: value,
                                      type: type))
    }
}
