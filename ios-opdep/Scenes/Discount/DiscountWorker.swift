//
//  DiscountWorker.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 14/05/2021.
//

import Foundation
import ReactiveSwift

class DiscountWorker {
    
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchDataDiscount(userId: String,
                           codeNumber: String?) -> SignalProducer<DiscountResponse, APIError> {
        let request = DiscountRequest(userId: userId,
                                      codeNumber: codeNumber)
        return apiService.reactive.response(of: request)
    }
    
    func submitOrder(with userId: String,
                     phone: String,
                     city: String,
                     address: String,
                     email: String,
                     realName: String,
                     codeNumber: String) -> SignalProducer<SubmitOrderResponse, APIError> {
        let request = SubmitOrderRequest(userId: userId,
                                         phone: phone,
                                         city: city,
                                         address: address,
                                         email: email,
                                         realName: realName,
                                         codeNumber: codeNumber)
        return apiService.reactive.response(of: request)
    }
    
    func confirmOrder(with orderId: String,
                      status: Int) -> SignalProducer<ConfirmOrderResponse, APIError> {
        let request = ConfirmOrderRequest(orderId: orderId, status: status)
        return apiService.reactive.response(of: request)
    }
}
