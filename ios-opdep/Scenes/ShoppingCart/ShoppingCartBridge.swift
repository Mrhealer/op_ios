//
//  ShoppingCartBridge.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 11/05/2021.
//
import UIKit
import ReactiveSwift
import ReactiveCocoa
class ShoppingCartBridge: ListViewBridge<ShoppingCartViewModel> {
    
    let labelEmptyData = StyleLabel(text: Localize.ShoppingCart.empty,
                                    font: .font(style: .medium, size: 16),
                                    textAlignment: .center)

    override func render(tableView: UITableView, in parentView: UIView) {
        viewController?.view.backgroundColor = .white
        setupView(tableView: tableView, in: parentView)
    }
    private func setupView(tableView: UITableView, in parentView: UIView) {
        tableView.separatorStyle = .none
        let navigationBar = CustomNavigation(title: Localize.ShoppingCart.title,
                                             viewController: viewController)
        navigationBar.backBarItem.isHidden = viewModel.typeScreen == TypeScreen.root ? true : false
        let stackView = buildTotalPriceView()
        let buttonCheckout = StyleButton(title: Localize.ShoppingCart.next,
                                         titleFont: .font(style: .medium, size: 16),
                                         titleColor: .white,
                                         backgroundColor: .init(hexString: "B877B1"), rounded: true,
                                         cornerRadius: 13)
        parentView.addSubviews(navigationBar, tableView,
                               labelEmptyData,
                               stackView, buttonCheckout)
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(parentView.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(stackView.snp.top).offset(-10)
        }
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
        buttonCheckout.snp.makeConstraints {
            let bottom = viewModel.typeScreen == TypeScreen.root ?
                AppConstants.Common.tabBarHeight : 0
            $0.height.equalTo(46)
            $0.top.equalTo(stackView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(parentView.safeAreaLayoutGuide)
                .offset(-bottom - 20)
        }
        labelEmptyData.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
        }
        viewController?.bindViewModel(viewModel)
        viewModel.fetchDataShoppingCart()

        [tableView, stackView, buttonCheckout, labelEmptyData].forEach {
            $0.isHidden = true
        }
        viewModel.shoppingCart.signal.observeValues { [weak self] in
            guard let sself = self else { return }
            let data = $0
            [tableView, stackView, buttonCheckout].forEach {
                $0.isHidden = data.count == 0 ? true : false
            }
            sself.labelEmptyData.isHidden = data.count == 0 ? false : true
        }
        buttonCheckout.reactive.pressed = CocoaAction(viewModel.navigateToDiscountAction)
    }

    private func buildTotalPriceView() -> UIStackView {
        let stackView = UIStackView()
        let quantityView = TotalPriceItemView(title: Localize.ShoppingCart.quantity)
        let shippingView = TotalPriceItemView(title: Localize.ShoppingCart.shipping)
        let totalView = TotalPriceItemView(title: Localize.ShoppingCart.total)
        totalView.labelTitle.font = .font(style: .medium, size: 15)
        let spec = StackSpec(axis: .vertical,
                             items: [quantityView, shippingView, totalView],
                             distribution: .fillEqually, spacing: 6,
                             contentInsets: .init(top: 0, left: 24, bottom: 0, right: 24))
        stackView.load(spec: spec)
        
        quantityView.labelValue.reactive.text <~ viewModel.quantityProduct
        shippingView.labelValue.reactive.text <~ viewModel.shippingPrice
        totalView.labelValue.reactive.text <~ viewModel.totalPrice
        return stackView
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
class TotalPriceItemView: UIView {
    let labelTitle: StyleLabel
    let labelValue: StyleLabel
    init(title: String) {
        labelTitle = StyleLabel(text: title,
                                font: .font(style: .regular, size: 15))
        labelValue = StyleLabel(font: .font(style: .medium, size: 15))
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        addSubviews(labelTitle, labelValue)
        labelTitle.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
        }
        labelValue.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
        }
    }
}
