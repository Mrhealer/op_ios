//
//  ShoppingCartItemViewCell.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 11/05/2021.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class CartItemViewCell: UITableViewCell {
    
    let containerView = UIView()
    let imageProduct = StyleImageView(contentMode: .scaleAspectFit)
    let nameProduct = StyleLabel(font: .font(style: .medium, size: 17))
    let price = StyleLabel()
    let labelQuantity = StyleLabel(font: .font(style: .regular, size: 16))
    let deleteButton = StyleButton(title: Localize.ShoppingCart.delete,
                                   titleFont: .font(style: .medium, size: 16),
                                   image: R.image.trash())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        backgroundColor = .white
        containerView.withBorder(width: 1, cornerRadius: 10, color: .gray)
        deleteButton.titleEdgeInsets = .init(top: 0, left: 6, bottom: 0, right: 0)
        let stackView = UIStackView()
        let spec = StackSpec(axis: .vertical,
                             items: [nameProduct, price, labelQuantity],
                             distribution: .fillEqually,
                             spacing: 6)
        stackView.load(spec: spec)
        contentView.addSubview(containerView)
        containerView.addSubviews(imageProduct, stackView, deleteButton)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-16)
        }
        imageProduct.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.size.equalTo(CGSize(width: 50, height: 100))
        }
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview()
            $0.left.equalTo(imageProduct.snp.right).offset(16)
            $0.bottom.equalToSuperview().offset(-20)
        }
        deleteButton.snp.makeConstraints {
            $0.right.bottom.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 70, height: 25))
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageProduct.image = nil
        nameProduct.text = nil
        price.text = nil
        labelQuantity.text = nil
    }
    
    func configure(viewModel: CartItemViewModel) {
        imageProduct.reactive.imageFromUrl <~ viewModel.imageProduct.producer
            .take(until: reactive.prepareForReuse)
            .skipNil()
        nameProduct.reactive.text <~ viewModel.productName.producer
            .take(until: reactive.prepareForReuse)
        labelQuantity.reactive.text <~ viewModel.quantity.producer
            .take(until: reactive.prepareForReuse)
        price.attributedText = viewModel.unitFromModel(model: viewModel.model)
        deleteButton.reactive.pressed = CocoaAction(viewModel.deleteAction)
    }
}
