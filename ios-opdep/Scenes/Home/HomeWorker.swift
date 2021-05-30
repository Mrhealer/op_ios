//
//  HomeWorker.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 24/04/2021.
//

import Foundation
import ReactiveSwift

class HomeWorker {
    
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchDataCategory() -> SignalProducer<[Categories], APIError> {
        let request = CategoryRequest()
        return apiService.reactive.response(of: request)
    }
}
