//
//  OrderHistoryCellViewModel.swift
//  OPOS
//
//  Created by Nguyễn Quang on 9/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class OrderHistoryCellViewModel {
    
    let model: OrderHistoryResponse
    let router: OrderHistoryRouter
    
    var orderNumber = MutableProperty<String>("")
    var statusText = MutableProperty<String>("")
    var dateCreateOrder = MutableProperty<String>("")
    var priceOrder = MutableProperty<String>("")
    
    let navigateToDetailAction: Action<Void, Void, Never>
    
    init(model: OrderHistoryResponse,
         apiService: APIService,
         router: OrderHistoryRouter) {
        self.model = model
        self.router = router
        orderNumber = MutableProperty(model.orderHistoryNumber)
        statusText  = MutableProperty(model.orderStatusText)
        dateCreateOrder = MutableProperty(model.dateCreateOrder)
        priceOrder = MutableProperty(model.totalPriceOrder)
        
        navigateToDetailAction = Action { [router] in
            router.navigateToOrderDetail(orderHistory: model)
            return .empty
        }
    }
}
