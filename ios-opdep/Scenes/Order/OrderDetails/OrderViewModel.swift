//
//  OrderViewModel.swift
//  ios-opdep
//
//  Created by Nguyen Anh on 06/06/2021.
//

import UIKit
import PromiseKit

class OrderViewModel: BaseViewModel {

    func cancelOrder(orderId: String) {
        let apiName = ApiName.cancelOrder
        firstly { () -> Promise<ApiResponse> in
            let params = ["order_id": orderId]
            return ApiClient.shared.callApi(HomeApi.cancelOrder(params: params))
        }.done { [weak self] (response) in
            
            self?.responseSubject.onNext((api: apiName,
                                          isRequestSuccess: true,
                                          message: nil))
            return
        }.catch { [weak self] (_) in
            self?.responseSubject.onNext((api: apiName,
                                          isRequestSuccess: false,
                                          message: "error"))

        }
    }
    
}

extension OrderViewModel {
        
    struct ApiName {
        static let cancelOrder = "cancelOrder"
    }
        
}
