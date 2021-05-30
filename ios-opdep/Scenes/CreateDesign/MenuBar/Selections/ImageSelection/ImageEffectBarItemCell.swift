//
//  ImageEffectBarItemCell.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/9/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class ImageEffectBarItemCell: BarItemCell {
    func configure(viewModel: ImageEffectItemViewModel) {
        titleLabel.text = viewModel.effect.title
        imageView.image = nil
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
