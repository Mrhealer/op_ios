//
//  CreateDesignViewModel.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 04/05/2021.
//

import Foundation
import ReactiveSwift

enum CreateDesignError: LocalizedError {
    case noImage
    case noText
    var errorDescription: String? {
        switch self {
        case .noImage: return Localize.Editor.editorNoImage
        case .noText: return Localize.Editor.editorNoText
        }
    }
}

enum SelectionContext {
    case none
    case backgroundImage
    case frameImage
    case styleFrameImage
    case text
    case sticker
    case imageEffect
    case styleFrame
    case color
}

enum TakePhotoContext {
    case background
    case frame
    case sticker
    case styleFrame
}

enum DesignType {
    case phone
    case wallpaper
}

class CreateDesignViewModel: BasicViewModel {
    typealias OutputError = Error
    let errors: Signal<Error, Never>
    let isLoading: Signal<Bool, Never>
    let backAction: Action<Void, Void, Never>
    let nextAction: Action<OutPutFileModel?, Void, Never>
    let generateOutputAction: Action<(Data?, Data?, Data?), OutPutFileModel?, Never>
    let checkImageExistAction: Action<ImageContext, ImageContext, CreateDesignError>
    let resizeImageAction: Action<UIImage, UIImage?, Never>
    let fillResizedImageAction: Action<UIImage?, UIImage, Never>
    
    // flow change Product:
    // change product -> change template(-> redraw template) -> download resource -> draw resouces
    let selectDeviceAction: Action<ProductModel, ProductModel, Never>
    let changedTemplateAction: Action<ProductModel, TemplateModel?, Never>
    // flow change Template:
    // change template(-> draw template) -> download resource -> draw resouces
    let selectTemplateAction: Action<TemplateModel?, TemplateModel?, Never>
    let downloadResourcesAction: Action<TemplateModel?, (TemplateModel?, [UIImage?]), ImageDownloadError>
    
    let takePhotoContext = MutableProperty<TakePhotoContext>(.background)
    let selectionContext = MutableProperty<SelectionContext>(.none)
    // Menu Bar
    let menuBarViewModel: MenuBarViewModel
    let stickerSelectionViewModel: StickerSelectionViewModel
    let attributeTextViewModel: AttributeTextViewModel
    let imageSelectionViewModel: ImageSelectionViewModel
    let imageEffectsViewModel: ImageEffectsSelectionViewModel
    let styleFrameSelectionViewModel: StyleFrameSelectionViewModel
    let styleFrameInfosViewModel: StyleFrameInfosViewModel
    let colorSelectionViewModel: BackgroundColorSelectionViewModel
    // Design Layer
    let backgroundLayerViewModel: BackgroundLayerViewModel
    let frameTemplateLayerViewModel: FrameTemplateLayerViewModel
    let styleFrameLayerViewModel: StyleFrameLayerViewModel
    let textLayerViewModel: TextLayerViewModel
    let stickerLayerViewModel: StickerLayerViewModel
    
    private let router: CreateDesignRouter
    let product: MutableProperty<ProductModel?>
    let template: MutableProperty<TemplateModel?>
    let resources: MutableProperty<[UIImage?]>
    
    let imageDownloadWorker = ImageDownloadWorker()
    
    let designType: MutableProperty<DesignType>
    
    init(product: ProductModel?,
         resources: [UIImage?],
         template: TemplateModel? = nil,
         apiService: APIService,
         router: CreateDesignRouter,
         designType: DesignType = .phone) {
        self.resources = MutableProperty(resources)
        self.product = MutableProperty(product)
        self.template = MutableProperty(template)
        self.designType = MutableProperty(designType)
        self.router = router
        // Design Selections
        menuBarViewModel = .init()
        imageSelectionViewModel = .init(apiService: apiService)
        imageEffectsViewModel = .init()
        attributeTextViewModel = .init(apiService: apiService)
        stickerSelectionViewModel = .init(apiService: apiService)
        colorSelectionViewModel = .init(apiService: apiService)
        styleFrameLayerViewModel = .init()
        styleFrameInfosViewModel = .init()
        
        // Design Layers
        backgroundLayerViewModel = .init()
        frameTemplateLayerViewModel = .init()
        styleFrameSelectionViewModel = .init(apiService: apiService)
        textLayerViewModel = .init(apiService: apiService)
        stickerLayerViewModel = .init()
        
        // Actions
        backAction = Action { [router] in
            router.back()
            return .empty
        }
        
        nextAction = Action(state: self.product) { [router] product, designModel in
            guard let model = designModel, let product = product else { return .empty }
            router.navigateToBuy(product: product,
                                 designModel: model)
            return .init(value: ())
        }
        
        generateOutputAction = Action { input in
            SignalProducer { observer, _ in
                let (preview, image, print) = input
                observer.send(value: OutPutFileModel(preview: preview,
                                                     photo: image,
                                                     print: print))
                observer.sendCompleted()
            }.start(on: QueueScheduler(qos: .background))
        }
        
        checkImageExistAction = Action { [backgroundLayerViewModel, frameTemplateLayerViewModel, styleFrameLayerViewModel] input in
            switch input {
            case .background:
                if !backgroundLayerViewModel.existedBackground { return .init(error: .noImage)}
            case .frame:
                if !frameTemplateLayerViewModel.existedImage {
                    return .init(error: .noImage)
                }
            case .styleFrame:
                if !styleFrameLayerViewModel.existedImage {
                    return .init(error: .noImage)
                }
            }
            return .init(value: input)
        }
        
        selectDeviceAction = Action { .init(value: $0) }
        
        selectTemplateAction = Action { .init(value: $0) }
        
        changedTemplateAction = Action(state: self.template) { template, _ in
            .init(value: template)
        }
        
        downloadResourcesAction = Action(state: self.product) { [imageDownloadWorker] product, input in
            
            var producers: [SignalProducer<UIImage?, ImageDownloadError>] = []
            if let product = product {
                producers.append(contentsOf: [imageDownloadWorker.fetchImage(url: product.backLayerImageUrl),
                                              imageDownloadWorker.fetchImage(url: product.middleLayerImageUrl),
                                              imageDownloadWorker.fetchImage(url: product.frontLayerImageUrl)])
            } else {
                producers.append(contentsOf: [imageDownloadWorker.fetchImage(url: nil),
                                              imageDownloadWorker.fetchImage(url: nil),
                                              imageDownloadWorker.fetchImage(url: nil)])
            }
            
            if let template = input {
                if let frameLayer = template.frameLayer,
                   let frameLayerBackground = frameLayer.background, let url = URL(string: frameLayerBackground) {
                    producers.append(imageDownloadWorker.fetchImage(url: url))
                } else {
                    producers.append(imageDownloadWorker.fetchImage(url: nil))
                }
                if let frameLayer = template.frameLayer,
                   let frameLayerMask = frameLayer.mask, let url = URL(string: frameLayerMask) {
                    producers.append(imageDownloadWorker.fetchImage(url: url))
                } else {
                    producers.append(imageDownloadWorker.fetchImage(url: nil))
                }
                if let frameLayer = template.frameLayer,
                   let frames = frameLayer.frames {
                    for frame in frames {
                        if let frameBackground = frame.background, let url = URL(string: frameBackground) {
                            producers.append(imageDownloadWorker.fetchImage(url: url))
                        } else {
                            producers.append(imageDownloadWorker.fetchImage(url: nil))
                        }
                        if let frameMask = frame.mask, let url = URL(string: frameMask) {
                            producers.append(imageDownloadWorker.fetchImage(url: url))
                        } else {
                            producers.append(imageDownloadWorker.fetchImage(url: nil))
                        }
                    }
                }
            }
            return SignalProducer<UIImage?, ImageDownloadError>.zip(producers).map { (input, $0)}
        }
        
        resizeImageAction = Action { image in
            SignalProducer { observer, _ in
                observer.send(value: image.resized(toKB: 3072))
                observer.sendCompleted()
            }
        }
        
        fillResizedImageAction = Action(state: takePhotoContext) { [backgroundLayerViewModel, frameTemplateLayerViewModel, styleFrameLayerViewModel, stickerLayerViewModel] context, image in
            switch context {
            case .background:
                backgroundLayerViewModel.currentImage.swap(image)
            case .frame:
                frameTemplateLayerViewModel.setImage(image,
                                                     isOrigin: true)
            case .sticker:
                stickerLayerViewModel.pickedImage.swap(image)
            case .styleFrame:
                styleFrameLayerViewModel.setImage(image: image,
                                                  isOrigin: true)
            }
            return .empty
        }
        
        nextAction <~ generateOutputAction.values.observe(on: UIScheduler())
        
        errors = Signal.merge(checkImageExistAction.errors.map { $0 },
                              downloadResourcesAction.errors.map { $0 })
        
        isLoading = Signal.merge(backgroundLayerViewModel.fetchImageAction.isExecuting.signal,
                                 frameTemplateLayerViewModel.fetchImageAction.isExecuting.signal,
                                 styleFrameLayerViewModel.fetchImageAction.isExecuting.signal,
                                 styleFrameLayerViewModel.fetchFrameAction.isExecuting.signal,
                                 downloadResourcesAction.isExecuting.signal,
                                 generateOutputAction.isExecuting.signal,
                                 resizeImageAction.isExecuting.signal)
        
        // Binding
        binding()
    }
    
    private func bindingToSelections() {
        // Dùng để xác định xem selection nào được select (để show hoặc ẩn selection)
        selectionContext <~ Signal.merge(menuBarViewModel.selectedItem.signal
                                            .skipNil()
                                            .filter { $0.type == .background }
                                            .map { _ in .backgroundImage },
                                         checkImageExistAction.values.map { _ in .imageEffect },
                                         frameTemplateLayerViewModel.selectedFrame.signal
                                            .skipNil()
                                            .map { _ in .frameImage },
                                         menuBarViewModel.selectedItem.signal
                                            .skipNil()
                                            .filter { $0.type == .sticker }
                                            .map { _ in .sticker },
                                         menuBarViewModel.selectedItem.signal
                                            .skipNil()
                                            .filter { $0.type == .text }
                                            .map { _ in .text },
                                         menuBarViewModel.selectedItem.signal
                                            .skipNil()
                                            .filter { $0.type == .color }
                                            .map { _ in .color },
                                         styleFrameLayerViewModel.selectedStyleFrame.signal.skipNil().map { _ in .styleFrame },
                                         styleFrameSelectionViewModel.insertImageAction.values.map { _ in .styleFrameImage },
                                         selectDeviceAction.values.map { _ in .none },
                                         selectTemplateAction.values.map { _ in .none },
                                         textLayerViewModel.selectedNewLabel.signal
                                            .filter { $0 == true }
                                            .map { _ in .text },
                                         textLayerViewModel.deletedLabel.signal.map { _ in .none },
                                         styleFrameLayerViewModel.deleteFrameAction.values.map { _ in .none })
        // image selection
        imageSelectionViewModel.imageContext <~ Signal.merge(menuBarViewModel.selectedItem.signal
                                                                .skipNil()
                                                                .filter { $0.type == .background }
                                                                .map { _ in .background },
                                                             frameTemplateLayerViewModel.selectedFrame.signal
                                                                .skipNil()
                                                                .map { _ in .frame },
                                                             styleFrameLayerViewModel.selectedStyleFrame.signal.skipNil().map { _ in .styleFrame })
        imageSelectionViewModel.isSelected <~ Signal.merge(selectionContext.signal.map { if $0 == .backgroundImage || $0 == .frameImage || $0 == .styleFrameImage { return true }
            return false
        },
        stickerLayerViewModel.selectedNewSticker.signal
            .filter { $0 == true }.negate())
        
        // image effect selection
        imageEffectsViewModel.isSelected <~ Signal.merge(selectionContext.signal.map { $0 == .imageEffect },
                                                         stickerLayerViewModel.selectedNewSticker.signal
                                                            .filter { $0 == true }.negate())
        imageEffectsViewModel.imageContext <~ imageSelectionViewModel.imageContext.skipRepeats()
        
        // text selection
        attributeTextViewModel.isSelected <~ Signal.merge(selectionContext.signal.map { $0 == .text },
                                                          stickerLayerViewModel.selectedNewSticker.signal
                                                            .filter { $0 == true }.negate())
        attributeTextViewModel.fontSizeValue <~ textLayerViewModel.currentFontSize
        attributeTextViewModel.interlineValue <~ textLayerViewModel.currentStyles.map { $0.0 }
        attributeTextViewModel.distanceValue <~ textLayerViewModel.currentStyles.map { $0.1 }
        attributeTextViewModel.shadowValue <~ textLayerViewModel.currentStyles.map { $0.2 }
        attributeTextViewModel.showedKeyboard <~ Signal.merge(textLayerViewModel.deletedLabel.signal.map { _ in false },
                                                              textLayerViewModel.selectedNewLabel.signal.filter { $0 == true })
        
        // style frame selection
        styleFrameSelectionViewModel.isSelected <~ Signal.merge(selectionContext.signal.map { $0 == .styleFrame },
                                                                stickerLayerViewModel.selectedNewSticker.signal
                                                                    .filter { $0 == true }.negate())
        
        // sticker selection
        stickerSelectionViewModel.isSelected <~ selectionContext.signal.map { $0 == .sticker }
        
        // Hiển thị / ẩn selection chọn màu
        colorSelectionViewModel.isSelected <~ selectionContext.signal.map { $0 == .color }
        
        // show frame in style frames
        styleFrameInfosViewModel.frameInfos <~ styleFrameLayerViewModel.frames.map { $0.enumerated().map { (index, item) in StyleFrameInfoModel(id: item.id, name: "Frame \(index)") } }
    }
    
    private func bindingToLayers() {
        // Chỉnh sửa giao diện cho background view
        backgroundLayerViewModel.coloredImage <~ colorSelectionViewModel.selectedColorAction.values
            .filter { $0.1 == .background }
            .map { $0.0 }
            .skipNil()
        // frame template layer
        frameTemplateLayerViewModel.changeWithNewTemplate <~ Signal.merge(selectDeviceAction.values.map { _ in false },
                                                                          selectTemplateAction.values.map { _ in true })
        frameTemplateLayerViewModel.frameLayerModel <~ template.producer
            .skipNil()
            .map { $0.frameLayer }
        frameTemplateLayerViewModel.deselect <~ Signal.merge(stickerLayerViewModel.selectedNewSticker.signal
                                                                .filter { $0 == true }
                                                                .map { _ in },
                                                               imageSelectionViewModel.hideAction.values,
                                                               selectionContext.signal
                                                                .filter {
                                                                    if $0 == .backgroundImage
                                                                        || $0 == .frameImage
                                                                        || $0 == .styleFrameImage
                                                                        || $0 == .imageEffect {
                                                                        return false
                                                                    }
                                                                    return true
                                                                }.skipRepeats().map { _ in },
                                                               imageEffectsViewModel.hideAction.values)
        imageSelectionViewModel.selectedColorAction.values
            .filter { $0.1 == .frame }
            .map { $0.0 }.observeValues { [frameTemplateLayerViewModel] in
                frameTemplateLayerViewModel.setImage($0,
                                                     isOrigin: true)
            }
        
        // Chỉnh sửa giao diện cho frame view
        styleFrameLayerViewModel.addFrameAction <~ menuBarViewModel.selectedItem.signal
            .skipNil()
            .filter { $0.type == .styleFrame }
            .map { _ in }
        styleFrameLayerViewModel.fetchFrameAction <~ styleFrameSelectionViewModel.selectedFrame
        styleFrameLayerViewModel.bringFrameToFrontAction <~ styleFrameInfosViewModel.selectedFrame.signal.skipNil()
        styleFrameLayerViewModel.deselect <~ Signal.merge(stickerLayerViewModel.selectedNewSticker.signal
            .filter { $0 == true }
            .map { _ in },
                                                          selectionContext.signal
                                                            .filter { !($0 == .styleFrame || $0 == .styleFrameImage || $0 == .imageEffect) }
                                                            .map { _ in })
        imageSelectionViewModel.selectedColorAction.values
            .filter { $0.1 == .styleFrame }
            .map { $0.0 }.observeValues { [styleFrameLayerViewModel] in
                styleFrameLayerViewModel.setImage(image: $0,
                                                  isOrigin: true)
            }
        
        // Chỉnh sửa giao diện cho text
        textLayerViewModel.templateLabels <~ template.producer
            .skipNil()
            .map { $0.labels }
        textLayerViewModel.addText <~ menuBarViewModel.selectedItem.signal
            .skipNil()
            .filter { $0.type == .text }
            .map { _ in }
        textLayerViewModel.fetchFontAction <~ attributeTextViewModel.selectedFont.signal.skipNil()
        textLayerViewModel.changedColor <~ attributeTextViewModel.selectedColor.signal
            .skipNil()
            .map { $0.color }
        textLayerViewModel.changedAlign <~ attributeTextViewModel.selectedAlign.signal
            .map { $0 }
        textLayerViewModel.changedTextCased <~ attributeTextViewModel.selectedTextCased.signal
            .map { $0 }
        textLayerViewModel.interlineValue <~ attributeTextViewModel.interlineValue
        textLayerViewModel.distanceValue <~ attributeTextViewModel.distanceValue
        textLayerViewModel.shadowValue <~ attributeTextViewModel.shadowValue
        textLayerViewModel.fontSizeValue <~ attributeTextViewModel.fontSizeValue
        textLayerViewModel.deselect <~ Signal.merge(stickerLayerViewModel.selectedNewSticker.signal
            .filter { $0 == true }
            .map { _ in },
                                                       selectionContext.signal
                                                        .filter { $0 != .text }
                                                        .map { _ in },
                                                       attributeTextViewModel.doneAction.values.filter { $0 == false }.map { _ in })
        
        // Chỉnh sửa giao diện cho sticker view
        stickerLayerViewModel.deselect <~ selectionContext.signal
            .filter { $0 != .sticker }
            .map { _ in }
        stickerLayerViewModel.imageUrl <~ stickerSelectionViewModel.selectedSticker.signal
            .skipNil()
        
        // binding các effects từ imageEffectSelection tới background, frame, style frame layer
        [backgroundLayerViewModel, frameTemplateLayerViewModel, styleFrameLayerViewModel].forEach { effectFilterViewModel in
            effectFilterViewModel.changedSaturationAction <~ imageEffectsViewModel.saturationContextAction.values
                .filter { $0.1 == effectFilterViewModel.imageContext }
                .map { $0.0 }
            effectFilterViewModel.changedBrightnessAction <~ imageEffectsViewModel.brightnessContextAction.values
                .filter { $0.1 == effectFilterViewModel.imageContext }
                .map { $0.0 }
            effectFilterViewModel.changedContrastAction <~ imageEffectsViewModel.contrastContextAction.values
                .filter { $0.1 == effectFilterViewModel.imageContext }
                .map { $0.0 }
            effectFilterViewModel.selectFilterTemplateAction <~ imageEffectsViewModel.selectFilterAction.values
                .filter { $0.1 == effectFilterViewModel.imageContext }
                .map { $0.0 }
                .skipNil()
            effectFilterViewModel.fetchImageAction <~ imageSelectionViewModel.selectedImageAction.values
                .filter { $0.1 == effectFilterViewModel.imageContext }
                .map { $0.0 }
                .skipNil()
            if let viewModel = effectFilterViewModel as? ImageActions {
                viewModel.reset <~ imageSelectionViewModel.resetPhotoAction.values
                    .filter { $0.1 == effectFilterViewModel.imageContext }
                    .map { $0.0 }
                viewModel.rotate <~ imageSelectionViewModel.rotatePhotoAction.values
                    .filter { $0.1 == effectFilterViewModel.imageContext }
                    .map { $0.0 }
                viewModel.flip <~ imageSelectionViewModel.flipPhotoAction.values
                    .filter { $0.1 == effectFilterViewModel.imageContext }
                    .map { $0.0 }
            }
        }
    }
    
    private func binding() {
        bindingToSelections()
        
        bindingToLayers()
        
        // menu bar thay đổi khi template thay đổi hoặc chọn free style
        menuBarViewModel.menus <~ template.producer.map {
            if let template = $0 {
                if let frameLayer = template.frameLayer, frameLayer.color == nil {
                    return [MenuBarItemModel(type: .text),
                            MenuBarItemModel(type: .sticker)]
                } else {
                    return [MenuBarItemModel(type: .background),
                            MenuBarItemModel(type: .text),
                            MenuBarItemModel(type: .sticker)]
                }
            } else {
                return [MenuBarItemModel(type: .background),
                        MenuBarItemModel(type: .color),
                        MenuBarItemModel(type: .text),
                        MenuBarItemModel(type: .sticker)]
            }
        }
        
        // khi chọn menu là text thì reset lại text selection về tab đầu tiên
        menuBarViewModel.selectedItem.signal
            .skipNil()
            .filter { $0.type == .text }
            .observeValues { [attributeTextViewModel] _ in
                attributeTextViewModel.menuBarViewModel.didSelectItemAt(indexPath: IndexPath(row: 0,
                                                                                             section: 0))
            }
                
        changedTemplateAction <~ selectDeviceAction.values
        downloadResourcesAction <~ Signal.merge(changedTemplateAction.values,
                                                selectTemplateAction.values)
        template <~ downloadResourcesAction.values.map { $0.0 }
        resources <~ downloadResourcesAction.values.map { $0.1 }
        // để xác định là chọn ảnh từ library từ đâu ( cho background, frame template hay style frame)
        takePhotoContext <~ Signal.merge(stickerSelectionViewModel.takePhotoAction.values.map { _ in .sticker },
                                         imageSelectionViewModel.imageContext.signal.map {
                                            if $0 == .background { return .background }
                                            if $0 == .frame { return .frame }
                                            return .styleFrame })
        
        // kiểm tra xem ảnh đã được chọn hay chưa thì mới apply được effect
        checkImageExistAction <~ imageSelectionViewModel.showImageEffectsAction.values
        
        // resize ảnh chọn từ library để tối ưu dung lượng tạo file pdf để in
        fillResizedImageAction <~ resizeImageAction.values.skipNil().observe(on: UIScheduler())
    }
    
    // 3 tiện ích cho việc layout các layer và collage
    var backgroundLayerWidth: Int {
        guard let product = product.value else {
            return 0
        }
        return product.backgroundLayerWidth(with: UIScreen.main.bounds.size)
    }
    
    var frameDesign: CGRect {
        // product = nil (mean: designType = wallpaper)
        let navigationBarHeight: CGFloat = 50
        let menuBarHeight: CGFloat = 68
        let top: CGFloat = 10
        let bottom: CGFloat = 16
        let safeAreaBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let safeAreaTop = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        let height = UIScreen.main.bounds.height - menuBarHeight - navigationBarHeight - top - bottom - safeAreaBottom - safeAreaTop
        let width = UIScreen.main.bounds.width - 16 - 16
        let originX = (UIScreen.main.bounds.width - width) / 2
        let originY = navigationBarHeight + top + safeAreaTop
        return CGRect(x: originX,
                      y: originY,
                      width: width,
                      height: height)
    }
    
    var bottomSpaceFromDesign: CGFloat {
        return UIScreen.main.bounds.height - frameDesign.height - frameDesign.origin.y
    }
}
