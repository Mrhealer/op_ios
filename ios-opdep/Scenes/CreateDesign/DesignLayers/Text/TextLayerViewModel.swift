//
//  TextLayerViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 10/23/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class TextLayerViewModel {
    // output from textlayer
    let selectedNewLabel = MutableProperty<Bool>(false)
    let deletedLabel = MutableProperty<Void>(())
    // text from label se duoc edit in textview
    let editedText = MutableProperty<String?>(nil)
    let currentStyles = MutableProperty<(Float, Float, Float)>((0, 0, 0))
    let currentFontSize = MutableProperty<Float>(16)
    
    // input to textlayer
    let templateLabels = MutableProperty<[LabelModel]?>(nil)
    // text duoc thay doi va update vao label
    let changedText = MutableProperty<String?>(nil)
    let addText = MutableProperty<Void>(())
    let deselect = MutableProperty<Void>(())
    let changedColor = MutableProperty<UIColor?>(nil)
    let changedAlign = MutableProperty<NSTextAlignment?>(nil)
    let changedTextCased = MutableProperty<TextCased?>(nil)
    // Đồng bộ với attributes
    let fontSizeValue = MutableProperty<Float>(0)
    let interlineValue = MutableProperty<Float>(0)
    let distanceValue = MutableProperty<Float>(0)
    let shadowValue = MutableProperty<Float>(0)
    var input = MutableProperty<(Float, Float, Float)?>(nil)
    
    let applyAttributesAction: Action<Void, (Float, Float, Float)?, Never>
    
    let fetchFontAction: Action<DesignImageModel, String?, Never>
    let worker: TextLayerWorker
    init(apiService: APIService) {
        worker = TextLayerWorker(apiService: apiService)
        
        fetchFontAction = Action { [worker] input in
            worker.fetchFont(from: input)
        }
        applyAttributesAction = Action(state: input) { .init(value: $0) }
        
        input <~ SignalProducer.combineLatest(interlineValue.producer,
                                              distanceValue.producer,
                                              shadowValue.producer)
        applyAttributesAction <~ SignalProducer.merge(interlineValue.producer.map { _ in },
                                                      distanceValue.producer.map { _ in },
                                                      shadowValue.producer.map { _ in })
    }
}
