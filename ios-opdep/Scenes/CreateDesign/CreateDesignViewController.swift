//
//  CreateDesignViewController.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 04/05/2021.
//

import Foundation
import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa
import Photos

class CreateDesignViewController: BasicViewController {
    override var shouldHideNavigationBar: Bool { true }
    // MARK: Define design part
    // case phone layer
    private let backLayer = UIImageView()
    // middle layer
    private let middleLayer = UIImageView()
    // camera phone layer
    private let frontLayer = UIImageView()
    // contain multi design view in detail container and middleLayer for create print data
    private let designContainer = UIView()
    private let detailContainer = UIView()
    // main container: include backLayer, frontLayer, and designContainer
    private let mainContainer = UIView()
    private let saveDesignButton = StyleButton(image: R.image.save_design())
    // Menu Bar
    private let menuBar: MenuBarView
    private let stickerSelection: StickerSelection
    private let attributeText: AttributeText
    private let imageSelection: ImageSelection
    private let imageEffectsSelection: ImageEffectsSelection
    private let styleFrameSelection: StyleFrameSelection
    private let styleFrameInfosView: StyleFrameInfosView
    private let backgroundColorSelection: BackgroundColorSelection
    
    private var bottomImageSelectionConstraint: Constraint?
    private var bottomFrameSelectionConstraint: Constraint?
    private var bottomStickerSelectionConstraint: Constraint?
    private var bottomColorSelectionConstraint: Constraint?
    private var bottomTextSelectionConstraint: Constraint?

    // Design layers
    let backgroundLayer: BackgroundLayer
    let stickerLayer: StickerLayer
    let styleFrameLayer: StyleFrameLayer
    private let textLayer: TextLayer
    
    // Navigation
    private let nextBarItem = StyleButton(image: R.image.navigation_next(),
                                           backgroundColor: .clear)
    private let backBarItem = StyleButton(image: R.image.navigation_back(),
                                          backgroundColor: .clear)
    private let titleLabel = StyleLabel(text: Localize.Editor.title,
                                        font: UIFont.important(size: 16),
                                        textAlignment: .center)
    //
    private let showLayersButton = StyleButton(image: R.image.style_frame_layers())
    
    let viewModel: CreateDesignViewModel
    init(viewModel: CreateDesignViewModel) {
        self.viewModel = viewModel
        // Menu Bar
        menuBar = .init(viewModel: viewModel.menuBarViewModel)
        stickerSelection = .init(viewModel: viewModel.stickerSelectionViewModel)
        attributeText = .init(viewModel: viewModel.attributeTextViewModel)
        imageSelection = .init(viewModel: viewModel.imageSelectionViewModel)
        imageEffectsSelection = .init(viewModel: viewModel.imageEffectsViewModel)
        styleFrameSelection = .init(viewModel: viewModel.styleFrameSelectionViewModel)
        styleFrameInfosView = .init(viewModel: viewModel.styleFrameInfosViewModel)
        backgroundColorSelection = .init(viewModel: viewModel.colorSelectionViewModel)
        // Layer
        let extraSpace: CGFloat = 0
        let width = viewModel.frameDesign.size.width + extraSpace
        let height = viewModel.frameDesign.size.height + extraSpace
        let originX = (UIScreen.main.bounds.width - width) / 2
        let originY = viewModel.frameDesign.origin.y - extraSpace / 2
        
        let frame = CGRect(x: originX,
                           y: originY,
                           width: width,
                           height: height)
        let designFrame = CGRect(origin: .zero,
                                 size: frame.size)
        detailContainer.frame = frame
        backgroundLayer = .init(viewModel: viewModel.backgroundLayerViewModel,
                                frame: designFrame)
        styleFrameLayer = .init(viewModel: viewModel.styleFrameLayerViewModel,
                                frame: designFrame)
        textLayer = .init(viewModel: viewModel.textLayerViewModel,
                          frame: designFrame)
        stickerLayer = .init(viewModel: viewModel.stickerLayerViewModel,
                             frame: designFrame)
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        prepare()
    }
    
    override func didReceiveMemoryWarning() {
        viewModel.imageDownloadWorker.clearCache()
        super.didReceiveMemoryWarning()
    }
    
    private func prepare() {
        // MARK: Create and add views
        mainContainer.addSubviews(designContainer, middleLayer, backLayer, frontLayer)
        let navigationBar = buildNavigationBar()
        
        view.addSubviews(mainContainer,
                         menuBar,
                         showLayersButton,
                         saveDesignButton,
                         imageSelection,
                         stickerSelection,
                         attributeText,
                         imageEffectsSelection,
                         styleFrameSelection,
                         navigationBar,
                         styleFrameInfosView,
                         backgroundColorSelection)
        
        // backLayer: Ảnh vùng bỏ qua
        // middleLayer: Ảnh điện thoại viền trong suốt
        // frontLayer: Ảnh điện thoại viền trắng
        // detailContainer vùng thiết kế
        designContainer.addSubviews(detailContainer)
        detailContainer.addSubviews(backgroundLayer, styleFrameLayer, stickerLayer, textLayer)
        // MARK: Layout views
        // Design layer
        [frontLayer, middleLayer, backLayer].forEach {
            $0.snp.makeConstraints {
                $0.top.equalTo(navigationBar.snp.bottom).offset(10)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalTo(menuBar.snp.top).offset(-16)
            }
        }
        [designContainer, styleFrameInfosView].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        mainContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        // Menu Bar
        menuBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(68)
        }
        stickerSelection.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(240)
            bottomStickerSelectionConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        styleFrameSelection.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(240)
            bottomFrameSelectionConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        imageSelection.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(240)
            bottomImageSelectionConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        backgroundColorSelection.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(240)
            bottomColorSelectionConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        attributeText.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(240)
            bottomTextSelectionConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        imageEffectsSelection.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(180)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        // Navigation
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        showLayersButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalTo(menuBar.snp.top).offset(-8)
        }
        saveDesignButton.snp.makeConstraints {
            $0.size.equalTo(36)
            $0.leading.equalToSuperview().offset(8)
            $0.top.equalTo(navigationBar.snp.bottom).offset(8)
        }
        // Config Properties
        backLayer.contentMode = .scaleAspectFill
        middleLayer.contentMode = .scaleAspectFill
        frontLayer.contentMode = .scaleAspectFill
        
        detailContainer.clipsToBounds = true
        middleLayer.clipsToBounds = true
        frontLayer.clipsToBounds = true
        
        detailContainer.backgroundColor = .white
        backgroundLayer.backgroundColor = .white
        
        // fix when pop navigation??
        view.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel(viewModel)
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frontLayer.alpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func buildNavigationBar() -> UIView {
        let navigationBar = UIView()
        let space = UIView()
        navigationBar.addSubviews(backBarItem, titleLabel, nextBarItem, space)
        backBarItem.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.top.leading.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backBarItem.snp.trailing)
            $0.trailing.equalTo(nextBarItem.snp.leading)
            $0.top.bottom.equalToSuperview()
        }
        nextBarItem.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.top.trailing.bottom.equalToSuperview()
        }
        space.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        space.backgroundColor = .init(hexString: "#000000", alpha: 0.5)
        navigationBar.backgroundColor = .white
        return navigationBar
    }
    
    private func binding() {
        // MARK: Back Layer And Front Layer, Middle Layer
        backLayer.reactive.isHidden <~ viewModel.designType.map { $0 == .wallpaper }
        middleLayer.reactive.isHidden <~ viewModel.designType.map { $0 == .wallpaper }
        frontLayer.reactive.isHidden <~ viewModel.designType.map { $0 == .wallpaper }
        viewModel.resources.producer.startWithValues { [backLayer, middleLayer, frontLayer] in
            backLayer.image = R.image.background_frame()
            if $0.count > 1 {
                middleLayer.image = $0[0]
                frontLayer.image = $0[1]
            }
        }
    
        // MARK: Actions binding
        nextBarItem.reactive.isHidden <~ viewModel.designType.producer.map { $0 == .wallpaper }
        saveDesignButton.reactive.isHidden <~ viewModel.designType.producer.map { $0 == .phone }
        showLayersButton.reactive.isHidden <~ viewModel.styleFrameInfosViewModel.frameInfos.producer.map { $0.count == 0 }
        styleFrameInfosView.reactive.isHidden <~ showLayersButton.reactive.controlEvents(.touchUpInside).map { _ in false }
        backBarItem.reactive.pressed = CocoaAction(viewModel.backAction)
        nextBarItem.reactive.pressed = CocoaAction(viewModel.generateOutputAction) { [weak self] _ in
            guard let sself = self else { return (nil, nil, nil) }
            sself.frontLayer.alpha = 1
            sself.stickerLayer.deselect()
            sself.textLayer.deselect()
            sself.styleFrameLayer.deselect()
            let preview = sself.mainContainer.imageFromView(scale: 0.75)
            let image = CommonUtility.createPdfFromView(designLayer: sself.mainContainer.layer,
                                                        desginBounds: sself.mainContainer.bounds)
            let print = CommonUtility.createPdfFromView(designLayer: sself.designContainer.layer,
                                                        desginBounds: sself.designContainer.bounds)
            return (preview, image, print)
        }
        
        Signal.merge(viewModel.imageSelectionViewModel.takePhotoAction.values,
                     viewModel.stickerSelectionViewModel.takePhotoAction.values).observeValues { [weak self] in
                        self?.showPickerImageWithType(sourceType: .photoLibrary)
        }
        
        viewModel.imageSelectionViewModel.takeCameraAction.values.observeValues { [weak self] in
            self?.showPickerImageWithType(sourceType: .camera)
        }
        
        // MARK: Others binding
        attributeText.textView.reactive.becomeFirstResponder <~ viewModel.textLayerViewModel.selectedNewLabel.signal
            .filter { $0 == true }
            .map { _ in }
        
        attributeText.textView.reactive.text <~ viewModel.textLayerViewModel.editedText

        viewModel.textLayerViewModel.selectedNewLabel.signal.filter { $0 == true }.observeValues { [weak self] _ in
            guard let sself = self else { return }
            sself.viewModel.attributeTextViewModel.updateWhenChangeText()
        }
        
        viewModel.textLayerViewModel.changedText <~ attributeText.textView.reactive.continuousTextValues
        
        viewModel.frameTemplateLayerViewModel.selectedFrame.signal
            .filter { $0 == nil }.observeValues { [weak self] _ in
                guard let sself = self else { return }
                sself.imageEffectsSelection.isHidden = true
                sself.animateView(with: sself.bottomImageSelectionConstraint,
                                  offset: 240,
                                  completion: {
                                    sself.imageSelection.isHidden = true
                })
        }
        
        // MARK: Hiển thị selection được chọn
        viewModel.imageSelectionViewModel.isSelected.signal.observeValues { [weak self] in
            if $0, let sself = self {
                sself.showSelection(selection: sself.imageSelection,
                                    contraint: sself.bottomImageSelectionConstraint)
            }
        }
        
        viewModel.styleFrameSelectionViewModel.isSelected.signal.observeValues { [weak self] in
            if $0, let sself = self {
                sself.showSelection(selection: sself.styleFrameSelection,
                                    contraint: sself.bottomFrameSelectionConstraint)
            }
        }
        
        viewModel.stickerSelectionViewModel.isSelected.signal.observeValues { [weak self] in
            if $0, let sself = self {
                sself.showSelection(selection: sself.stickerSelection,
                                    contraint: sself.bottomStickerSelectionConstraint)
            }
        }
        
        viewModel.colorSelectionViewModel.isSelected.signal.observeValues { [weak self] in
            if $0, let sself = self {
                sself.showSelection(selection: sself.backgroundColorSelection,
                                    contraint: sself.bottomColorSelectionConstraint)
            }
        }
        
        viewModel.attributeTextViewModel.isSelected.signal.observeValues { [weak self] in
            if $0, let sself = self {
                sself.showSelection(selection: sself.attributeText,
                                    contraint: sself.bottomTextSelectionConstraint)
            }
        }
        
        saveDesignButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            guard let sself = self, let image = sself.detailContainer.takeSnapshot(scale: 1) else { return }
            UIImageWriteToSavedPhotosAlbum(image,
                                           sself,
                                           #selector(sself.image(_:didFinishSavingWithError:contextInfo:)),
                                           nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if error != nil {
                presentSimpleAlert(title: "Thông báo", message: "Can't save to library.")
            } else {
                presentSimpleAlert(title: "Thông báo", message: "Save to library successfully.")
            }
        }
    
    private func updateContraint(contraint: Constraint?, offset: CGFloat) {
        contraint?.update(offset: offset)
    }
    
    func animateView(with contraint: Constraint?,
                     offset: CGFloat,
                     animatedDuration: TimeInterval = 0.3,
                     completion: (() -> Void)? = nil) {
        updateContraint(contraint: contraint,
                        offset: offset)
        UIView.animate(withDuration: animatedDuration,
                       animations: { [weak self] in
                        guard let sself = self else { return }
                        sself.view.layoutIfNeeded()
            },
                       completion: { _ in
                        guard let completion = completion else { return }
                        completion()
        })
    }
    
    private func showSelection(selection: UIView, contraint: Constraint?) {
        animateView(with: contraint,
                    offset: 240,
                    animatedDuration: 0,
                    completion: { [weak self, selection] in
                        selection.isHidden = false
                        self?.animateView(with: contraint,
                                         offset: 0)
        })
    }
}
