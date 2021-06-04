//
//  TemplateGridViewCell.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 6/4/21.
//

import Foundation
import ReactiveSwift
import SDWebImage

class TemplateGirdCell: UICollectionViewCell {
    
    let image = UIImageView()
    let name = StyleLabel(font: .font(style: .medium, size: 14))
    let price = StyleLabel(font: .font(style: .regular, size: 12))
    let priceDiscount = StyleLabel(font: .font(style: .regular, size: 12),
                                   textColor: UIColor.Basic.priceDiscount)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        [name, price, priceDiscount].forEach {
            $0.text = nil
        }
    }
    
    func prepare() {
        contentView.withBorder(width: 0.5, color: .gray)
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        addSubviews(image, name, price, priceDiscount)
        price.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-5)
        }
        priceDiscount.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-5)
        }
        name.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(price.snp.top).offset(-5)
        }
        image.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.left.right.equalToSuperview()
            $0.bottom.equalTo(name.snp.top).offset(-10)
        }
    }
    
    func configure(viewModel: ProductModel) {
        name.text = viewModel.name
        priceDiscount.text = UtilityPrice
            .formatCurrency(currencyString: viewModel.priceDiscount.asStringOrEmpty())
        let textPrice = UtilityPrice
            .formatCurrency(currencyString: viewModel.price.asStringOrEmpty())
        price.attributedText = UtilityPrice
            .formatPriceOriginal(price: textPrice,
                                 textColor: UIColor.Basic.black,
                                 fontName: .font(style: .regular, size: 12))
        
        if let urlString = viewModel.imgUrl, let url = URL(string: urlString) {
            if urlString.range(of: "webp") != nil {
                image.sd_setImage(with: url, completed: nil)
            }else {
                image.af.setImage(withURL: url)
            }
 
        }
    }
}
