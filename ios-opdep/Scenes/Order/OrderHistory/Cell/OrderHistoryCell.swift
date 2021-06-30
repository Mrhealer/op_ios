//
//  OrderHistoryCell.swift
//  OPOS
//
//  Created by Hoc Nguyen on 7/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class OrderHistoryCell: UITableViewCell {
    
    private let containerView = StyleView(backgroundColor: .white)
    private let saperatorLine = StyleView(backgroundColor: .gray)
    private let iconlistHistory: UIImageView = {
        let image = UIImageView()
//        image.image = UIImage.OrderHistory.listHistory
        return image
    }()
    private let labelOrderId = StyleLabel(font: .font(style: .medium, size: 15))
    private let labelOrderStatus = StyleLabel(font: .font(style: .medium, size: 14),
                                              textColor: .init(hexString: "8D7AA5"),
                                              textAlignment: .right)
    private let labelDateCreateOrder = StyleLabel(font: .font(style: .medium, size: 14),
                                                  textColor: .init(hexString: "000000", alpha: 0.5))
    private let labelpriceOrder = StyleLabel(font: .font(style: .medium, size: 14))
    private let buttonViewOrder = StyleButton(title: "Xem chi tiết",
                                              titleFont: .font(style: .medium, size: 16),
                                              titleColor: .init(hexString: "8D7AA5"),
                                              rounded: true, cornerRadius: 5,
                                              borderColor: UIColor.init(hexString: "8D7AA5").cgColor,
                                              borderWidth: 1)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        contentView.backgroundColor = .init(hexString: "E5E5E5")
        contentView.addSubview(containerView)
        
        containerView.addSubviews(iconlistHistory,
                                  labelOrderId,
                                  labelOrderStatus,
                                  saperatorLine,
                                  labelDateCreateOrder,
                                  labelpriceOrder,
                                  buttonViewOrder)
        
        containerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        iconlistHistory.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(20)
            $0.width.equalTo(0)
        }
        labelOrderId.snp.makeConstraints {
            $0.centerY.equalTo(iconlistHistory)
            $0.left.equalTo(iconlistHistory.snp.right).offset(8)
        }
        labelOrderStatus.snp.makeConstraints {
            $0.centerY.equalTo(iconlistHistory)
            $0.right.equalToSuperview().offset(-24)
            $0.left.equalTo(labelOrderId.snp.right).offset(8)
        }
        saperatorLine.snp.makeConstraints {
            $0.top.equalTo(labelOrderId.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(1)
        }
        labelDateCreateOrder.snp.makeConstraints {
            $0.top.equalTo(saperatorLine.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
        labelpriceOrder.snp.makeConstraints {
            $0.top.equalTo(labelDateCreateOrder.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
        buttonViewOrder.snp.makeConstraints {
            $0.top.equalTo(labelpriceOrder.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().offset(-16)
        }
        buttonViewOrder.adjustsImageWhenHighlighted = false
        buttonViewOrder.isUserInteractionEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelOrderId.text = nil
        labelOrderStatus.text = nil
        labelDateCreateOrder.text = nil
        labelpriceOrder.text = nil
    }
    
    func configure(viewModel: OrderHistoryCellViewModel) {
        labelOrderId.reactive.text <~ viewModel.orderNumber.producer
            .take(until: reactive.prepareForReuse)
        labelOrderStatus.reactive.text <~ viewModel.statusText.producer
            .take(until: reactive.prepareForReuse)
        labelDateCreateOrder.reactive.text <~ viewModel.dateCreateOrder.producer
            .take(until: reactive.prepareForReuse)
        labelpriceOrder.reactive.text <~ viewModel.priceOrder.producer
            .take(until: reactive.prepareForReuse)
//        buttonViewOrder.reactive.pressed = CocoaAction(viewModel.navigateToDetailAction)
    }

}
