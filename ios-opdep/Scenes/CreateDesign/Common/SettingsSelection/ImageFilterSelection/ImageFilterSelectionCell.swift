//
//  ImageFilterSelectionCell.swift
//  OPOS
//
//  Created by Tran Van Dinh on 8/1/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class ImageFilterSelectionCell: UICollectionViewCell {
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        backgroundColor = .clear
    }
    
    private func prepare() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(model: ImageFilterModel) {
        imageView.image = UIImage(named: model.imageName)
        imageView.clipsToBounds = true
        model.isSelected.producer.take(until: reactive.prepareForReuse).startWithValues { [weak self] in
            if $0 {
                self?.imageView.withBorder(width: 2,
                                      cornerRadius: 8,
                                      color: .init(hexString: "#D07A00"))
            } else {
                self?.imageView.withBorder(width: 0,
                                           cornerRadius: 8,
                                           color: .clear)
            }
        }
    }
}
