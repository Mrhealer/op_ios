//
//  FrameTemplateLayerViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/14/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

struct FrameModel: Codable {
    struct Content: Codable {
        let centerX: CGFloat
        let centerY: CGFloat
        let width: CGFloat
        let height: CGFloat
        let parentWidth: CGFloat
        let parentHeight: CGFloat
        let angle: CGFloat
        
        let originalImageData: Data?
        let imageData: Data?
        
        init(centerX: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat, parentWidth: CGFloat, parentHeight: CGFloat, angle: CGFloat, originalImageData: Data?, imageData: Data?) {
            self.centerX = centerX
            self.centerY = centerY
            self.width = width
            self.height = height
            self.parentWidth = parentWidth
            self.parentHeight = parentHeight
            self.angle = angle
            
            self.originalImageData = originalImageData
            self.imageData = imageData
        }
        
        var scaleY: CGFloat { centerY / parentHeight }
        var scaleX: CGFloat { centerX / parentWidth }
        var scaleH: CGFloat { height / parentHeight }
        var scaleW: CGFloat { width / parentWidth }
        var ratio: CGFloat { width / height }
    }
    let onTop: Int
    let centerX: CGFloat
    let centerY: CGFloat
    let width: CGFloat
    let height: CGFloat
    let parentWidth: CGFloat
    let parentHeight: CGFloat
    let angle: CGFloat
    
    let background: String?
    let mask: String?
    
    let contents: [Content]
    
    init(onTop: Int,
         centerX: CGFloat,
         centerY: CGFloat,
         width: CGFloat,
         height: CGFloat,
         parentWidth: CGFloat,
         parentHeight: CGFloat,
         angle: CGFloat,
         background: String?,
         mask: String?,
         contents: [Content]) {
        self.onTop = onTop
        self.centerX = centerX
        self.centerY = centerY
        self.width = width
        self.height = height
        self.parentWidth = parentWidth
        self.parentHeight = parentHeight
        self.angle = angle
        self.background = background
        self.mask = mask
        self.contents = contents
    }
    
    // thiet ke dang lay man hinh chuan la 375x812
    var scaleY: CGFloat { centerY / parentHeight }
    var scaleX: CGFloat { centerX / parentWidth }
    var scaleH: CGFloat { height / parentHeight }
    var scaleW: CGFloat { width / parentWidth }
    var ratio: CGFloat { width / height }
}

struct FrameLayerModel: Codable {
    let background: String?
    let mask: String?
    let color: String?
    let width: CGFloat
    let height: CGFloat
    let frames: [FrameModel]?
    
    init(background: String?, mask: String?, color: String?, width: CGFloat, height: CGFloat, frames: [FrameModel]?) {
        self.background = background
        self.mask = mask
        self.color = color
        self.width = width
        self.height = height
        self.frames = frames
    }
    
    var coloredImage: UIImage? {
        guard let color = color else { return nil }
        return UIImage.imageWithColor(.init(hexString: color))
    }
}

enum TextAlignment: String, Codable {
    case left
    case center
    case right
    
    var alignment: NSTextAlignment {
        switch self {
        case .left: return .left
        case .center: return .center
        case .right: return .right
        }
    }
}

struct LabelModel: Codable {
    let centerX: CGFloat
    let centerY: CGFloat
    let width: CGFloat
    let height: CGFloat
    let parentWidth: CGFloat
    let parentHeight: CGFloat
    let angle: CGFloat
    
    let fontSize: CGFloat
    let text: String
    let color: String
    let font: String?
    let alignment: TextAlignment?
    init(centerX: CGFloat,
         centerY: CGFloat,
         width: CGFloat,
         height: CGFloat,
         parentWidth: CGFloat,
         parentHeight: CGFloat,
         angle: CGFloat,
         fontSize: CGFloat,
         text: String,
         color: String,
         font: String?,
         alignment: TextAlignment?) {
        self.centerX = centerX
        self.centerY = centerY
        self.width = width
        self.height = height
        self.parentWidth = parentWidth
        self.parentHeight = parentHeight
        self.angle = angle
        self.fontSize = fontSize
        self.text = text
        self.color = color
        self.font = font
        self.alignment = alignment
    }
    
    var scaleY: CGFloat { centerY / parentHeight }
    var scaleX: CGFloat { centerX / parentWidth }
    var scaleH: CGFloat { height / parentHeight }
    var scaleW: CGFloat { width / parentWidth }
}

class FrameViewModel {
    let originalImage = MutableProperty<UIImage?>(nil)
    let image = MutableProperty<UIImage?>(nil)
    let backgroundImage = MutableProperty<UIImage?>(nil)
    let maskImage = MutableProperty<UIImage?>(nil)
    let rotate = MutableProperty<Void>(())
    let flip = MutableProperty<Void>(())
    let id: String = UUID().uuidString
}

class StyleFrameViewModel: FrameViewModel { }

class FrameTemplateViewModel: FrameViewModel {
    var selectedContentId: String?
    let model: FrameModel
    init(model: FrameModel) {
        self.model = model
    }
}

struct TemplateModel: Storable {
    let id: Int64
    let name: String?
    let image: String?
    let frameLayer: FrameLayerModel?
    let labels: [LabelModel]?
    
    init(id: Int64,
         name: String,
         image: String?,
         frameLayer: FrameLayerModel?,
         labels: [LabelModel]?) {
        self.id = id
        self.name = name
        self.image = image
        self.frameLayer = frameLayer
        self.labels = labels
    }
}

// For structure 2
struct TemplateResponse: Decodable {
    let id: Int64
    let name: String
    let image: String?
    let content: String
}

// For generating content string
struct TemplateContent: Decodable {
    let frameLayer: FrameLayerModel
    let labels: [LabelModel]?
}

struct StoredFrameImages {
    let originalImage: UIImage?
    let image: UIImage?
}

class FrameTemplateLayerViewModel: EffectFilterViewModel, ImageActions {
    let frameLayerModel = MutableProperty<FrameLayerModel?>(nil)
    let frames = MutableProperty<[FrameTemplateViewModel]>([])
    let selectedFrame = MutableProperty<FrameTemplateViewModel?>(nil)
    let selectFrameAction: Action<FrameTemplateViewModel?, FrameTemplateViewModel?, Never>
    let isExistedImage = MutableProperty<Bool>(false)
    let shouldAdjustDesign = MutableProperty<Bool>(false)
    
    let reset = MutableProperty<Void>(())
    let rotate = MutableProperty<Void>(())
    let flip = MutableProperty<Void>(())
    let deselect = MutableProperty<Void>(())
    
    let changeWithNewTemplate = MutableProperty<Bool>(true)
    let processTemplateAction: Action<FrameLayerModel?, [FrameTemplateViewModel], Never>
    let templateInfo: Property<(Bool, [FrameTemplateViewModel])>
    
    let selectedImages = MutableProperty<[UIImage?]>([])
    var cachedImages: [String: [UIImage?]] = [:]

    override init() {
        templateInfo = changeWithNewTemplate.combineLatest(with: frames)
        selectFrameAction = Action { .init(value: $0) }
        processTemplateAction = Action(state: templateInfo) { templateInfo, frameLayerModel in
            if templateInfo.0,
                let frameLayerModel = frameLayerModel,
                let frames = frameLayerModel.frames {
                return .init(value: frames.map { FrameTemplateViewModel(model: $0) })
            }
            return .init(value: templateInfo.1)
        }
        super.init()
        imageContext = .frame
        selectedFrame <~ Signal.merge(selectFrameAction.values,
                                      deselect.signal.map { _ in nil })
        Signal.merge(changedSaturationAction.values,
                     changedBrightnessAction.values,
                     changedContrastAction.values,
                     selectFilterTemplateAction.values).observeValues { [weak self] in
                        self?.setImage($0)
        }
        fetchImageAction.values.observeValues { [weak self] in
            self?.setImage($0,
                           isOrigin: true)
        }
        // Khi chọn 1 frame thì lấy ảnh gốc trong frame được chọn
        currentImage <~ selectedFrame.signal
            .skipNil()
            .map { $0.originalImage.value }
        frames <~  processTemplateAction.values.map { $0 }
        processTemplateAction <~ frameLayerModel.signal
    }
    
    func setImage(_ image: UIImage?, isOrigin: Bool = false) {
        guard let selectedFrameValue = selectedFrame.value else { return }
        selectedFrameValue.image.swap(image)
        isExistedImage.swap(image != nil)
        // ảnh gốc được lấy từ server hoặc từ thư viện ảnh sẽ được store
        if isOrigin {
            currentImage.swap(image)
            selectedFrameValue.originalImage.swap(image)
        }
        if let selectedContentId = selectedFrameValue.selectedContentId {
            cachedImages[selectedContentId] = [selectedFrameValue.image.value, selectedFrameValue.originalImage.value]
        }
    }
    
    var existedImage: Bool {
        guard let selectedFrameValue = selectedFrame.value else { return false }
        return selectedFrameValue.image.value != nil
    }
}
