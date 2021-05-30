//
//  ProductWorker.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 03/05/2021.
//

import Foundation
import ReactiveSwift

class ProductWorker {
    
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchProducts(categoryId: String) -> SignalProducer<[ProductModel], APIError> {
        let request = ProductVariantsRequest(categoryId: categoryId)
        return apiService.reactive.response(of: request)
    }
}
