//
//  CategoryBarItemCell.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import SnapKit
import AlamofireImage
import ReactiveSwift

class CategoryBarItemCell: BarItemCell {
    func configure(viewModel: CategoryBarItemViewModel) {
        titleLabel.reactive.text <~ viewModel.model.producer
            .take(until: reactive.prepareForReuse)
            .map { $0.title }
        imageView.reactive.imageFromUrl <~ viewModel.model.producer
            .take(until: reactive.prepareForReuse)
            .map { $0.url }
            .skipNil()
        viewModel.isSelected.producer
            .take(until: reactive.prepareForReuse).startWithValues { [weak self] in
                self?.focusedImageView.isHidden = !$0
                var alpha: CGFloat = 0.4
                if $0 { alpha = 1 }
                self?.titleLabel.alpha = alpha
                self?.imageView.alpha = alpha
        }
    }
}
