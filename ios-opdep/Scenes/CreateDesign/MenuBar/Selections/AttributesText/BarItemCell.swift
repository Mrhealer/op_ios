//
//  BarItemCell.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/3/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit

class BarItemCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = StyleLabel(font: UIFont.important(size: 10),
                                textColor: .black,
                                textAlignment: .center)
    let focusedImageView = UIImageView(image: nil)
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
        titleLabel.text = nil
    }
    
    func prepare() {
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        let contentInset = UIEdgeInsets(top: 8,
                                        left: 8,
                                        bottom: 8,
                                        right: 8)
        contentView.layoutMargins = contentInset
        contentView.addSubviews(imageView,
                                titleLabel,
                                focusedImageView)
        [imageView, titleLabel].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalTo(contentView.layoutMarginsGuide)
            }
        }
        focusedImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 7, height: 4))
            $0.centerX.bottom.equalToSuperview()
        }
    }
}
