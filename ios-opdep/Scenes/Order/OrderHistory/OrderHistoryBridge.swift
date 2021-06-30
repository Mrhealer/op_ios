//
//  OrderHistoryBridge.swift
//  OPOS
//
//  Created by Hoc Nguyen on 7/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit

class OrderHistoryBridge: ListViewBridge<OrderHistoryViewModel> {
    
    override func render(tableView: UITableView, in parentView: UIView) {
        viewController?.view.backgroundColor = .init(hexString: "E5E5E5")
        tableView.backgroundColor = .init(hexString: "E5E5E5")
        parentView.backgroundColor = .init(hexString: "E5E5E5")
        setupView(tableView: tableView,
                  in: parentView)
    }
    
    private func setupView(tableView: UITableView, in parentView: UIView) {
        let navigationBar = CustomNavigation(title: "Lịch sử đơn hàng",
                                             viewController: viewController)
        navigationBar.nextBarItem.isHidden = true
        let labelNoItems = StyleLabel(text: Localize.ShoppingCart.empty,
                                      font: .font(style: .medium, size: 16),
                                      textAlignment: .center)
        labelNoItems.isHidden = true
        
        parentView.addSubviews(navigationBar,
                               tableView,
                               labelNoItems)
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(parentView.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
        labelNoItems.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
        viewController?.bindViewModel(viewModel)
        tableView.separatorStyle = .none
        viewModel.fetchOrderHistory()
        //Check count items
        labelNoItems.isHidden = true
        viewModel.fetchOrderHistoryAction.values.observeValues {
            labelNoItems.isHidden = $0.count == 0 ? false : true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = OrderDetailsViewController(order: viewModel.orderHistory.value[indexPath.row].model)
        controller.modalPresentationStyle = .fullScreen
        controller.tapDeleteOrder.subscribe(onNext: { [weak self] _ in
//            self.viewModel.fetchDataShoppingCart()
            self?.viewModel.fetchOrderHistory()
        })
        AppLogic.shared.appRouter.rootNavigationController?.pushViewController(controller, animated: true)
    }
}
