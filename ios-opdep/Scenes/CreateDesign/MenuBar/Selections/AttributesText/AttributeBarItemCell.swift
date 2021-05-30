//
//  AttributeBarItemCell.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/3/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class AttributeBarItemViewModel {
    let attribute: Attribute
    let isSelected = MutableProperty<Bool>(false)
    
    init(attribute: Attribute) {
        self.attribute = attribute
    }
}

class AttributeBarItemCell: BarItemCell {
    override func prepare() {
        super.prepare()
        imageView.snp.remakeConstraints {
            $0.size.equalTo(24)
            $0.center.equalToSuperview()
        }
    }
    
    func configure(viewModel: AttributeBarItemViewModel) {
        titleLabel.text = nil
        imageView.image = viewModel.attribute.image
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
