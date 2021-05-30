//
//  DiscountViewController.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 14/05/2021.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import SkyFloatingLabelTextField

class DiscountViewController: LayoutSpecViewController {
    override var shouldHideNavigationBar: Bool { true }
    
    let buttonCheckout: StyleButton
    let viewModel: DiscountViewModel
    
    init(viewModel: DiscountViewModel) {
        self.viewModel = viewModel
        buttonCheckout = .init(title: "Mua hàng",
                               titleFont: .font(style: .bold, size: 16),
                               titleColor: .white,
                               backgroundColor: .init(hexString: "B877B1"), rounded: true,
                               cornerRadius: 13)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        configScroll()
        bindViewModel(viewModel)
        view.backgroundColor = UIColor.Basic.background
        viewModel.fetchDataDiscount()
        viewModel.fetchDataDiscountAction.values.observeValues { [weak self] in
            guard let sself = self else { return }
            if sself.viewModel.type.value == TypeFetchDataDiscount.discount && $0.status == 0 {
                sself.presentSimpleAlert(title: "Thông báo",
                                         message: $0.message)
            }
        }
        viewModel.submitOrderAction.values.observeValues { [viewModel] in
            if $0.status == 0 {
                self.showAlert(title: "Thông báo",
                               message: $0.message.asStringOrEmpty(),
                               textOk: "Xác nhận",
                               okCallBack: { viewModel.backToHome() })
            }
        }
    }
    
    override func prepareContentSpec() -> LayoutSpecViewController.Spec {
        let spec = super.prepareContentSpec()
        spec.spacing = 0
        spec.contentInsets = .init(top: 0, left: 24, bottom: 0, right: 24)
        let containerPadding = UIView()
        containerPadding.backgroundColor = .clear
        spec.add(buildNavigationBar())
            .spacer(size: 36)
            .add(buildInfoShipping())
            .spacer(size: 24)
            .add(buildDiscountCode())
            .spacer()
            .add(buildTotalPriceView())
            .spacer(size: 16)
            .add(buttonCheckout)
            .spacer(size: 20)
        buttonCheckout.snp.makeConstraints {
            $0.height.equalTo(46)
        }
        buttonCheckout.reactive.pressed = CocoaAction(viewModel.validateInfoShippingAction)
        return spec
    }

    func buildNavigationBar() -> LayoutSpecBuildable {
        let container = UIView()
        let navigationBar = CustomNavigation(title: Localize.ShoppingCart.title,
                                             viewController: self)
        navigationBar.nextBarItem.isHidden = true
        container.addSubviews(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(-24)
            $0.right.equalToSuperview().offset(24)
            $0.height.equalTo(60)
        }
        return container
    }
    
    func buildInfoShipping() -> LayoutSpecBuildable {
        let container = UIView()
        let title = StyleLabel(text: "Địa chỉ giao hàng",
                               font: .font(style: .bold, size: 16))
        let buttonUpdateInfo = StyleButton(title: "Chỉnh sửa",
                                           titleFont: .font(style: .regular, size: 14))
        let labelAddress = StyleLabel(font: .font(style: .medium, size: 14))
        container.addSubviews(title, buttonUpdateInfo, labelAddress)
        title.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        buttonUpdateInfo.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(title)
        }
        labelAddress.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
        }
        labelAddress.reactive.text <~ viewModel.addressShipping
        buttonUpdateInfo.reactive.pressed = CocoaAction(viewModel.navigateToProfileAction)
        return container
    }
    
    func buildDiscountCode() -> LayoutSpecBuildable {
        let container = UIView()
        let discountCode = SkyFloatingLabelTextField.create(placeholder: "Nhập giá khuyến mãi, giảm giá")
        let buttonConfirm = StyleButton(title: "Áp dụng",
                                        titleFont: .font(style: .regular, size: 14),
                                        titleColor: .white,
                                        backgroundColor: .init(hexString: "B877B1"), rounded: true,
                                        cornerRadius: 23,
                                        contentInsets: .init(top: 0, left: 20, bottom: 0, right: 20))
        container.addSubviews(discountCode, buttonConfirm)
        discountCode.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.top.left.bottom.equalToSuperview()
            $0.right.equalTo(buttonConfirm.snp.left).offset(-8)
        }
        buttonConfirm.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.right.equalToSuperview()
            $0.centerY.equalTo(discountCode)
        }
        viewModel.discountCode <~ discountCode.reactive.continuousTextValues
        buttonConfirm.reactive.pressed = CocoaAction(viewModel.confirmDiscountAction)
        return container
    }
    
    func buildTotalPriceView() -> LayoutSpecBuildable {
        let stackView = UIStackView()
        let shippingView = TotalPriceItemView(title: Localize.ShoppingCart.shipping)
        let totalView = TotalPriceItemView(title: Localize.ShoppingCart.total)
        totalView.labelTitle.font = .font(style: .medium, size: 16)
        totalView.labelValue.font = .font(style: .medium, size: 16)
        let spec = StackSpec(axis: .vertical,
                             items: [shippingView, totalView],
                             distribution: .fillEqually, spacing: 8)
        stackView.load(spec: spec)
        totalView.labelValue.reactive.text <~ viewModel.totalPrice
        shippingView.labelValue.reactive.text <~ viewModel.totalPriceShipping
        return stackView
    }
}
