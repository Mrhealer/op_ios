//
//  DeleteOrderRequest.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 12/05/2021.
//

import Foundation
import Alamofire

struct DeleteOrderRequest: RoutableRequest, EncodableRequest {
    public typealias Response = DeleteOrderResponse
    public let route = "shopCartInfo/delete"
    var body: DeleteOrderBodyRequest
    let method: HTTPMethod = .post
    init(userId: String,
         orderId: String) {
        body = DeleteOrderBodyRequest(userId: userId,
                                      orderId: orderId)
    }
}

struct DeleteOrderBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let user_id: String
    let order_upload_temp_id: String
    init(userId: String,
         orderId: String) {
        user_id = userId
        order_upload_temp_id = orderId
    }
}

struct DeleteOrderResponse: Decodable {
    let status: Int?
    let message: String?
}
