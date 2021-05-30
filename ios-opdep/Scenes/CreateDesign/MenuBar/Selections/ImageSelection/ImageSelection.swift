//
//  ImageSelection.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/20/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class ImageSelection: PassthroughView {
    let header = UIView()
    let menuBar = UIView()
    let detailContainer = UIView()
    let yourPhotoSelection = UIView()
    
    let viewModel: ImageSelectionViewModel
    init(viewModel: ImageSelectionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        isHidden = true
        detailContainer.backgroundColor = .white
        menuBar.backgroundColor = .white
        
        addSubviews(header, menuBar, detailContainer)
        detailContainer.addSubviews(yourPhotoSelection)
        
        buildHeader()
        buildYourPhoto()
        header.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.left.right.equalToSuperview()
        }
        menuBar.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.top.equalTo(header.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        detailContainer.snp.makeConstraints {
            $0.top.equalTo(menuBar.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        yourPhotoSelection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
                    
        viewModel.isSelected.signal.observeValues { [weak self] in
            if $0 {
                self?.show()
            } else {
                self?.isHidden = true
            }
        }
        
        yourPhotoSelection.reactive.isHidden <~ viewModel.categoryBarViewModel.selectedCategory.producer
            .skipNil()
            .map { $0.type != .user }
    }
    
    private func buildHeader() {
        header.backgroundColor = .white
        header.whiteShadow()
        let hideButton = StyleButton(image: R.image.confirm_icon())
        let labelTitle = StyleLabel(text: Localize.Editor.attributeImage,
                                    font: .font(style: .medium, size: 14),
                                    textAlignment: .center)
        header.addSubviews(hideButton, labelTitle)
        hideButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        labelTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        hideButton.reactive.pressed = CocoaAction(viewModel.hideAction)
    }
    
    func buildYourPhoto() {
        let rotateButton = StyleButton(image: R.image.rotate())
        let flipButton = StyleButton(image: R.image.flip())
        let deleteButton = StyleButton(image: R.image.trash())
        let effectsButton = StyleButton(image: R.image.effects())
        
        let specMenuBar = StackSpec(axis: .horizontal,
                                    distribution: .fillEqually,
                                    contentInsets: .init(top: 10, left: 0, bottom: 10, right: 0))
        specMenuBar.add(rotateButton,
                        flipButton,
                        effectsButton,
                        deleteButton)
        let stackViewMenuBar = specMenuBar.build()
        menuBar.addSubviews(stackViewMenuBar)
        stackViewMenuBar.backgroundColor = UIColor.Editor.bgMenuSelection
        stackViewMenuBar.layer.cornerRadius = 22
        stackViewMenuBar.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        // Camera
        let cameraContainer = UIView()
        let photoContainer = UIView()
        let cameraButton = StyleButton(title: Localize.Editor.editorFromCamera,
                                       titleFont: UIFont.primary(size: 16),
                                       rounded: true)
        let photoButton = StyleButton(title: Localize.Editor.editorFromPhotoLibrary,
                                      titleFont: UIFont.primary(size: 16),
                                      rounded: true)
        cameraContainer.addSubview(cameraButton)
        photoContainer.addSubview(photoButton)
        let stackSpec = StackSpec(axis: .vertical,
                                  distribution: .fillEqually,
                                  spacing: 16,
                                  contentInsets: UIEdgeInsets(top: 16,
                                                              left: 0,
                                                              bottom: 16,
                                                              right: 0))
        stackSpec.add(cameraContainer,
                      photoContainer)
        let stackView = stackSpec.build()
        yourPhotoSelection.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        [cameraButton, photoButton].forEach {
            $0.withBorder(width: 2, color: .black)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0,
                                                               left: 60,
                                                               bottom: 0,
                                                               right: 60))
            }
        }
        photoButton.reactive.pressed = CocoaAction(viewModel.takePhotoAction)
        cameraButton.reactive.pressed = CocoaAction(viewModel.takeCameraAction)
        rotateButton.reactive.pressed = CocoaAction(viewModel.rotatePhotoAction)
        flipButton.reactive.pressed = CocoaAction(viewModel.flipPhotoAction)
        effectsButton.reactive.pressed = CocoaAction(viewModel.showImageEffectsAction)
        
        deleteButton.reactive.isHidden <~ viewModel.imageContext.signal.map { $0 == .frame }
        deleteButton.reactive.pressed = CocoaAction(viewModel.resetPhotoAction)
    }
    
    @objc func hide() {
        viewModel.isSelected.swap(false)
    }
    
    private func show() {
        viewModel.fetchDesigns()
    }
}
