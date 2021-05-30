//
//  ConfirmOrderRequest.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 15/05/2021.
//

import Foundation
import Alamofire

struct ConfirmOrderRequest: RoutableRequest, EncodableRequest {
    public typealias Response = ConfirmOrderResponse
    public let route = "confirmOrder"
    var body: ConfirmOrderBodyRequest
    let method: HTTPMethod = .post
    init(orderId: String,
         status: Int) {
        body = ConfirmOrderBodyRequest(orderId: orderId,
                                       status: status)
    }
}

struct ConfirmOrderBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let order_id: String
    let status: Int
    init(orderId: String, status: Int) {
        order_id = orderId
        self.status = status
    }
}

struct ConfirmOrderResponse: Decodable {
    let status: Int?
    let message: String?
}
