//
//  ShoppingCartWorker.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 11/05/2021.
//

import Foundation
import ReactiveSwift

class ShoppingCartWorker {
    
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchDataShoppingCart(userId: String) -> SignalProducer<ShoppingCartResponse, APIError> {
        let request = ShoppingCartRequest(userId: userId)
        return apiService.reactive.response(of: request)
    }
    
    func deleteOrder(with userId: String,
                     orderId: String) -> SignalProducer<DeleteOrderResponse, APIError> {
        let request = DeleteOrderRequest(userId: userId, orderId: orderId)
        return apiService.reactive.response(of: request)
    }
}
