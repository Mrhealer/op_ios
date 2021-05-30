//
//  ChoosePickerWorker.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 16/05/2021.
//

import Foundation
import ReactiveSwift

class CustomPickerWorker {
    
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchCities() -> SignalProducer<[Cities], APIError> {
        let request = CityRequest()
        return apiService.reactive.response(of: request).map { $0.cities }
    }
}
