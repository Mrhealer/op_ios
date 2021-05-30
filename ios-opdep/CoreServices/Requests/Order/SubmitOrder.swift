//
//  SubmitOrder.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 15/05/2021.
//

import Foundation
import Alamofire

struct SubmitOrderRequest: RoutableRequest, EncodableRequest {
    public typealias Response = SubmitOrderResponse
    public let route = "v2/submitOrder"
    var body: SubmitOrderBodyRequest
    let method: HTTPMethod = .post
    init(zip: String = "10000",
         userId: String,
         phone: String,
         state: String = "",
         city: String,
         country: String = "Việt Nam",
         shippingType: Int = 0,
         address: String,
         osType: Int = AppConstants.OperationType.IOS,
         email: String,
         paymentOption: Int = 1,
         realName: String,
         ward: String = "",
         district: String = "",
         codeNumber: String) {
        body = SubmitOrderBodyRequest(zip: zip,
                                      userId: userId,
                                      phone: phone,
                                      state: state,
                                      city: city,
                                      country: country,
                                      shippingType: shippingType,
                                      address: address,
                                      osType: osType,
                                      email: email,
                                      paymentOption: paymentOption,
                                      realName: realName,
                                      ward: ward,
                                      district: district,
                                      codeNumber: codeNumber)
    }
}

struct SubmitOrderBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let zip: String
    let user_id: String
    let phone: String
    let state: String
    let city: String
    let country: String
    let shipping_type: Int
    let address: String
    let os_type: Int
    let email: String
    let payment_option: Int
    let realName: String,
    ward: String,
    district: String,
    code_number: String
    
    init(zip: String,
         userId: String,
         phone: String,
         state: String,
         city: String,
         country: String,
         shippingType: Int,
         address: String,
         osType: Int,
         email: String,
         paymentOption: Int,
         realName: String,
         ward: String,
         district: String,
         codeNumber: String) {
        self.zip = zip
        user_id = userId
        self.phone = phone
        self.state = state
        self.city = city
        self.country = country
        shipping_type = shippingType
        self.address = address
        os_type = osType
        self.email = email
        payment_option = paymentOption
        self.realName = realName
        self.ward = ward
        self.district = district
        self.code_number = codeNumber
    }
}

struct SubmitOrderResponse: Decodable {
    let status: Int?
    let message: String?
    let data: DataSubmitOrderResponse
}

struct DataSubmitOrderResponse: Decodable {
    let id: Int
}
