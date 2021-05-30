//
//  OrderHistoryRouter.swift
//  OPOS
//
//  Created by Hoc Nguyen on 7/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit

class OrderHistoryRouter: GenericRouter<UINavigationController> {
    
    func startWith(userId: String) {
        let vc = ListViewController(bridge:  OrderHistoryBridge(viewModel: .init(urserId: userId,
                                                                                 apiService: APIService.shared,
                                                                                 router: self)))
        navigate(to: vc)
    }
    
    func navigateToOrderDetail(orderHistory: OrderHistoryResponse) {
//        let signUpRouter = OrderDetailRouter(navigationController)
//        signUpRouter.startWith(orderHistory: orderHistory)
    }
    
}
