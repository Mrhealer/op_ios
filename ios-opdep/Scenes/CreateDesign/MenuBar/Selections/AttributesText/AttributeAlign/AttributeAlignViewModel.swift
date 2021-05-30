//
//  AttributeAlignViewModel.swift
//  OPOS
//
//  Created by Nguyễn Quang on 10/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

enum TextCased {
    case upperCased
    case lowerCased
    case capitalized
}

class AttributeAlignViewModel {
    let isSelected = MutableProperty<Bool>(false)
    var selectedAlign = MutableProperty<NSTextAlignment>(.center)
    var selectedTextCased = MutableProperty<TextCased?>(nil)
    let alignAction: Action<NSTextAlignment, NSTextAlignment, Never>
    let selectedTextCasedAction: Action<TextCased, TextCased, Never>
    let settingSliderViewModel: SettingSliderViewModel
    init() {
        settingSliderViewModel = .init(value: 0, type: .shadow)
        settingSliderViewModel.isSelected.swap(true)
        alignAction = Action { .init(value: $0) }
        selectedTextCasedAction = Action { .init(value: $0) }
        selectedAlign <~ alignAction.values
        selectedTextCased <~ selectedTextCasedAction.values
    }
}
