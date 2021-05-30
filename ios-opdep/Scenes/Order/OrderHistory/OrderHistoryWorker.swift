//
//  OrderHistoryWorker.swift
//  OPOS
//
//  Created by Hoc Nguyen on 7/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class OrderHistoryWorker {
    
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchOrderHistory(with userId: String) -> SignalProducer<[OrderHistoryResponse], APIError> {
        let request = OrderHistoryRequest(userId: userId)
        return apiService.reactive.response(of: request)
    }
}
