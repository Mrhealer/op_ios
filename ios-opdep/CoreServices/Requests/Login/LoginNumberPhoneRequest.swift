//
//  LoginNumberPhoneRequest.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 29/04/2021.
//

import Foundation
import Alamofire

struct LoginNumberPhoneRequest: RoutableRequest, EncodableRequest {
    public typealias Response = LoginNumberPhoneResponse
    public let route = "login-phone-number"
    var body: LoginNumberPhoneBodyRequest
    let method: HTTPMethod = .post
    init(phoneNumber: String) {
        body = LoginNumberPhoneBodyRequest(phoneNumber: phoneNumber)
    }
}

struct LoginNumberPhoneBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let phone_number_firebase: String
    let type: String
    init(phoneNumber: String, type: String = "2") {
        phone_number_firebase = phoneNumber
        self.type = type
    }
}

struct LoginNumberPhoneResponse: Decodable {
    let status: Int
    let data: LoginNumberPhone?
    let message: String
}

struct LoginNumberPhone: Decodable {
    let id: Int
}
