//
//  ImageFilterSelection.swift
//  OPOS
//
//  Created by Tran Van Dinh on 8/1/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class ImageFilterSelection: GridView<ImageFilterSelectionViewModel> {
    override func prepare() {
        super.prepare()
        collectionView.snp.remakeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        reactive.isHidden <~ viewModel.isSelected.negate()
    }
}
