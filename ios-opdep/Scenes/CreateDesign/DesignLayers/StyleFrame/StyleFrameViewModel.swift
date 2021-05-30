//
//  StyleFrameViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/27/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

enum FrameImageType {
    case content
    case mask
}

class StyleFrameLayerViewModel: EffectFilterViewModel, ImageActions {
    let addFrameAction: Action<Void, (StyleFrameViewModel, [StyleFrameViewModel]), Never>
    let frames = MutableProperty<[StyleFrameViewModel]>([])
    let selectedStyleFrame = MutableProperty<StyleFrameViewModel?>(nil)
    let selectFrameAction: Action<StyleFrameViewModel, StyleFrameViewModel, Never>
    let bringFrameToFrontAction: Action<StyleFrameInfoModel, StyleFrameViewModel, Never>
    let isExistedImage = MutableProperty<Bool>(false)
    
    let deleteFrameAction: Action<String, [StyleFrameViewModel], Never>
    let reset = MutableProperty<Void>(())
    let rotate = MutableProperty<Void>(())
    let flip = MutableProperty<Void>(())
    let deselect = MutableProperty<Void>(())
    
    var fetchFrameAction: Action<URL, UIImage?, ImageDownloadError> = Action { _ in .empty }
    override init() {
        selectFrameAction = Action { .init(value: $0) }
        addFrameAction = Action(state: frames) { frames in
            let newStyleFrame = StyleFrameViewModel()
            var newFrames: [StyleFrameViewModel] = frames
            newFrames.append(newStyleFrame)
            return .init(value: (newStyleFrame, newFrames))
        }
        deleteFrameAction = Action(state: frames) { frames, id in
            var newFrames: [StyleFrameViewModel] = frames
            newFrames.removeAll { $0.id == id }
            return .init(value: newFrames)
        }
        bringFrameToFrontAction = Action(state: frames) { frames, info in
            let selectedFrame = frames.first { $0.id == info.id }
            guard let frame = selectedFrame else { return .empty }
            return .init(value: frame)
        }
        super.init()
        imageContext = .styleFrame
        fetchFrameAction = Action { [worker] in
            worker.fetchImage(url: $0)
        }
        Signal.merge(changedSaturationAction.values,
                     changedBrightnessAction.values,
                     changedContrastAction.values,
                     selectFilterTemplateAction.values).observeValues { [weak self] in
                        self?.setImage(image: $0)
        }
        fetchImageAction.values.observeValues { [weak self] in
                        self?.setImage(image: $0,
                                       isOrigin: true)
        }
        // Khi chọn 1 frame thì lấy ảnh gốc trong frame được chọn
        currentImage <~ selectedStyleFrame.signal
            .skipNil()
            .map { $0.originalImage.value }
        frames <~ Signal.merge(addFrameAction.values.map { $0.1 },
                               deleteFrameAction.values)
        selectedStyleFrame <~ Signal.merge(selectFrameAction.values,
                                           addFrameAction.values.map { $0.0 },
                                           bringFrameToFrontAction.values)
        selectedStyleFrame.value?.maskImage <~ fetchFrameAction.values
        fetchFrameAction.values.observeValues { [weak self] in
            self?.setFrame(frame: $0)
        }
    }
    
    private func setFrame(frame: UIImage?) {
        guard let selectedFrameValue = selectedStyleFrame.value else { return }
        selectedFrameValue.maskImage.swap(frame)
    }
    
    func setImage(image: UIImage?, isOrigin: Bool = false) {
        guard let selectedFrameValue = selectedStyleFrame.value else { return }
        selectedFrameValue.image.swap(image)
        isExistedImage.swap(image != nil)
        // ảnh gốc được lấy từ server hoặc từ thư viện ảnh sẽ được store
        if isOrigin {
            currentImage.swap(image)
            selectedFrameValue.originalImage.swap(image)
        }
    }
    
    var existedImage: Bool {
        guard let selectedFrameValue = selectedStyleFrame.value else { return false }
        return selectedFrameValue.image.value != nil
    }
}
