//
//  BackgroundLayerViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/8/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift
import GPUImage

// FIXME: Maybe duplicate code ??
class EffectFilterViewModel {
    var imageContext: ImageContext = .background
    let worker: ImageDownloadWorker
    let fetchImageAction: Action<URL, UIImage?, ImageDownloadError>
    
    let currentImage = MutableProperty<UIImage?>(nil)
    // Saturation
    let saturationFilter: FilterOperation <GPUImageSaturationFilter>
    let changedSaturationAction: Action<Float, UIImage?, Error>
    // Brightness
    let brightnessFilter: FilterOperation <GPUImageBrightnessFilter>
    let changedBrightnessAction: Action<Float, UIImage?, Error>
    // Contrast
    let contrastFilter: FilterOperation <GPUImageContrastFilter>
    let changedContrastAction: Action<Float, UIImage?, Error>
    // filter template
    let selectFilterTemplateAction: Action<ImageFilterModel, UIImage?, Error>
    
    init() {
        worker = ImageDownloadWorker()
        
        fetchImageAction = Action { [worker] input in
            worker.fetchImage(url: input)
        }
        saturationFilter = FilterOperation <GPUImageSaturationFilter>(filterName: "Saturation",
                                                                      thumbnailName: nil,
                                                                      updateValue: { $0.saturation = CGFloat($1) })
        brightnessFilter = FilterOperation <GPUImageBrightnessFilter>(filterName: "Brightness",
                                                                      thumbnailName: nil,
                                                                      updateValue: { $0.brightness = CGFloat($1) })
        contrastFilter = FilterOperation <GPUImageContrastFilter>(filterName: "Contrast",
                                                                  thumbnailName: nil,
                                                                  updateValue: { $0.contrast = CGFloat($1) })
        changedSaturationAction = Action(unwrapping: currentImage) { [saturationFilter] image, value in
            saturationFilter.updateFilterValue(value: value)
            saturationFilter.outputFilter.useNextFrameForImageCapture()
            let output = saturationFilter.outputFilter.image(byFilteringImage: image)
            return .init(value: output)
        }
        
        changedBrightnessAction = Action(unwrapping: currentImage) { [brightnessFilter] image, value in
            brightnessFilter.updateFilterValue(value: value)
            brightnessFilter.outputFilter.useNextFrameForImageCapture()
            let output = brightnessFilter.outputFilter.image(byFilteringImage: image)
            return .init(value: output)
        }
        
        changedContrastAction = Action(unwrapping: currentImage) { [contrastFilter] image, value in
            contrastFilter.updateFilterValue(value: value)
            contrastFilter.outputFilter.useNextFrameForImageCapture()
            let output = contrastFilter.outputFilter.image(byFilteringImage: image)
            return .init(value: output)
        }
        
        selectFilterTemplateAction = Action(unwrapping: currentImage) { image, model in
            if model.index == 0 { return .init(value: image) }
            let filter = ToneCurveFilter(acvFileName: model.filterName)
            filter.useNextFrameForImageCapture()
            let output = filter.image(byFilteringImage: image)
            return .init(value: output)
        }
    }
}

// Chú ý: Hiện tại thì khi sang 1 filter mới thì lại thực hiện trên image ban đầu thay vì merge với ảnh đã filter trước đó.

protocol ImageActions {
    var reset: MutableProperty<Void> { get }
    var rotate: MutableProperty<Void> { get }
    var flip: MutableProperty<Void> { get }
}

class BackgroundLayerViewModel: EffectFilterViewModel, ImageActions {
    let reset = MutableProperty<Void>(())
    
    let rotate = MutableProperty<Void>(())
    
    let flip = MutableProperty<Void>(())
    
    let coloredImage = MutableProperty<UIImage?>(nil)
    
    override init() {
        super.init()
        currentImage <~ Signal.merge(fetchImageAction.values,
                                     coloredImage.signal)
    }
    
    var existedBackground: Bool { currentImage.value != nil }
}
