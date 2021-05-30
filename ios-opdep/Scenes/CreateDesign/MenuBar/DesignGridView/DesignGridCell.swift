//
//  DesignGridCell.swift
//  OPOS
//
//  Created by Tran Van Dinh on 8/5/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import SnapKit
import Kingfisher

class DesignGridCell: UICollectionViewCell {
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
    }
    
    func prepare() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        clipsToBounds = true
        withBorder(width: 1,
                   cornerRadius: self.frame.width / 2,
                   color: .init(hexString: "#000000",
                                alpha: 0.2))
    }

    func configure(model: DesignContent) {
        if !model.isColor {
            guard let url = model.url else { return }
            imageView.isHidden = false
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url)
            return
        }
        imageView.isHidden = true
        backgroundColor = model.color
    }
}
