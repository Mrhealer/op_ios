//
//  StickerSelection.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/21/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class StickerSelection: UIView {
    let viewModel: StickerSelectionViewModel
    let categoryBarView: GridView<CategoryBarViewModel>
    let pagingStickerView: PagingStickerView
    let hiddenButton = StyleButton(image: R.image.hidden_selection())
    let photoButton = StyleButton(title: Localize.Editor.editorYourPhoto,
                                  titleFont: UIFont.important(size: 10))
    init(viewModel: StickerSelectionViewModel) {
        self.viewModel = viewModel
        self.categoryBarView = .init(viewModel: viewModel.categoryBarViewModel)
        pagingStickerView = PagingStickerView(viewModel: viewModel.pagingStickerViewModel)
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        isHidden = true
        backgroundColor = .white
        let topSpace = UIView()
        let bottomSpace = UIView()
        addSubviews(pagingStickerView,
                   categoryBarView,
                   photoButton,
                   hiddenButton,
                   topSpace,
                   bottomSpace)
        pagingStickerView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(categoryBarView.snp.bottom)
        }
        categoryBarView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalToSuperview()
            $0.trailing.equalTo(hiddenButton.snp.leading)
            $0.leading.equalTo(photoButton.snp.trailing)
        }
        
        hiddenButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.trailing.equalToSuperview()
        }
        
        photoButton.snp.makeConstraints {
            $0.height.equalTo(categoryBarView.snp.height)
            $0.width.equalTo(80)
            $0.top.leading.equalToSuperview()
        }
        
        topSpace.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.top.equalToSuperview()
        }
        topSpace.backgroundColor = .init(hexString: "#000000", alpha: 0.2)
        
        bottomSpace.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(categoryBarView.snp.bottom)
        }
        bottomSpace.backgroundColor = .init(hexString: "#000000", alpha: 0.2)
        
        hiddenButton.addTarget(self,
                               action: #selector(hide),
                               for: .primaryActionTriggered)
        
        photoButton.reactive.pressed = CocoaAction(viewModel.takePhotoAction)
        
        viewModel.isSelected.signal.observeValues { [weak self] in
            $0 ? self?.show() : self?.hide()
        }
    }
    
    @objc func hide() {
        isHidden = true
    }
    
    func show() {
        viewModel.fetchImages()
    }
}
