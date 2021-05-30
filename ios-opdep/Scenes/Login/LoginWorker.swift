//
//  LoginWorker.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 27/04/2021.
//

import Foundation
import ReactiveSwift

class LoginWorker {
    
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func login(with phoneNumber: String) -> SignalProducer<LoginNumberPhoneResponse, APIError> {
        let request = LoginNumberPhoneRequest(phoneNumber: phoneNumber)
        return apiService.reactive.response(of: request)
    }

}
