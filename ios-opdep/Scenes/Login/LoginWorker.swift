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
    
    func login(with dataLogin: DataLogin ) -> SignalProducer<LoginNumberPhoneResponse, APIError> {
        let request = LoginNumberPhoneRequest(name: dataLogin.name ?? "", type: dataLogin.type, fb_id: dataLogin.fb_id ?? "", email_google :dataLogin.email_google!,apple_id: dataLogin.apple_id)
        return apiService.reactive.response(of: request)
    }
    
}
