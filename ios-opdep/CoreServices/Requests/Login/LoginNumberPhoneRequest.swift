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
    public let route = "login-v2"
    var body: LoginNumberPhoneBodyRequest
    let method: HTTPMethod = .post
    init(name: String, type :String,fb_id : String, email_google : String,apple_id:String?) {
        body = LoginNumberPhoneBodyRequest(name: name, type: type, fb_id: fb_id, email_google: email_google,apple_id: apple_id ?? "")
    }
}

struct LoginNumberPhoneBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let name : String?
    let type: String
    let fb_id: String?
    let email_google: String?
    let apple_id :String?
    init(name: String, type :String,fb_id : String, email_google : String,apple_id :String) {
        self.name = name
        self.type = type
        self.fb_id = fb_id
        self.email_google = email_google
        self.apple_id = apple_id
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
