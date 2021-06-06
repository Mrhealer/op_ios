//
//  OrderViewModel.swift
//  ios-opdep
//
//  Created by Nguyen Anh on 06/06/2021.
//

import UIKit
import PromiseKit

class OrderViewModel: BaseViewModel {

    func deleteOrder(productId: String) {
        let apiName = ApiName.deleteOrderApi
        firstly { () -> Promise<ApiResponse> in
            let params = ["user_id": APIService.shared.keyStore.userId.asStringOrEmpty(),
                          "order_upload_temp_id": productId]
            return ApiClient.shared.callApi(HomeApi.deleteOrder(params: params))
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
        static let deleteOrderApi = "deleteOrderApi"
    }
        
}
