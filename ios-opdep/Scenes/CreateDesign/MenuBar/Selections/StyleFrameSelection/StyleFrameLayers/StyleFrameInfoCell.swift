//
//  StyleFrameLayerCell.swift
//  OPOS
//
//  Created by Tran Van Dinh on 10/6/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit

class StyleFrameInfoCell: UICollectionViewCell {
    let imageView = UIImageView(image: R.image.eye_style_frame())
    let frameNameLabel = StyleLabel(font: UIFont.font(style: .regular,
                                                      size: 10))
    let separator = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        frameNameLabel.text = nil
    }
    
    func prepare() {
        contentView.addSubviews(imageView, frameNameLabel, separator)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 14, height: 10))
            $0.leading.equalToSuperview().offset(6)
            $0.centerY.equalToSuperview()
        }
        frameNameLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
        }
        
        separator.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    func configure(model: StyleFrameInfoModel) {
        frameNameLabel.text = model.name
        separator.backgroundColor = .init(hexString: "#000000", alpha: 0.3)
    }
    
    func hideSeparator() {
        separator.backgroundColor = .clear
    }
}
