//
//  DiscountRequest.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 14/05/2021.
//

import Foundation
import Alamofire

struct DiscountRequest: RoutableRequest, EncodableRequest {
    public typealias Response = DiscountResponse
    public let route = "v2/discount"
    var body: DiscountBodyRequest
    let method: HTTPMethod = .post
    init(userId: String,
         codeNumber: String?) {
        body = DiscountBodyRequest(userId: userId,
                                   codeNumber: codeNumber)
    }
}

struct DiscountBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let user_id: String
    let code_number: String?
    init(userId: String,
         codeNumber: String?) {
        user_id = userId
        code_number = codeNumber
    }
}

struct DiscountResponse: Decodable {
    let status: Int
    let message: String
    let data: Discount?
    let profile: Profile?
}

struct Discount: Decodable {
    let amountDiscount: Int?
    let amount: Int?
    let priceDiscount: Int?
    let priceShipping: Int?
    
    var totalPrice: String { UtilityPrice.formatCurrency(currencyString: amount.asIntOrEmpty()) }
    var totalPriceShipping: String {
        UtilityPrice.formatCurrency(currencyString: priceShipping.asIntOrEmpty()) }
    
    enum CodingKeys: String, CodingKey {
        case amountDiscount = "amount_discount"
        case amount
        case priceDiscount = "price_discount"
        case priceShipping = "price_shipping"
    }
}

struct Profile: Decodable {
    let id: Int
    let cityId: Int?
    let wardId: Int?
    let districtId: Int?
    let fullName: String?
    let email1: String?
    let address: String?
    let state: String?
    let phoneNumber: String?
    let isInfluencer: Int?
    let cityName: String?
    let districtName: String?
    let wardName: String?

    var nameShipping: String { fullName.asStringOrEmpty() }
    var phoneShipping: String { phoneNumber != nil ? " |\(phoneNumber.asStringOrEmpty())" : "" }
    var addressShipping: String { address != nil ? " |\(address.asStringOrEmpty())" : "" }
    var cityShipping: String { cityName != nil ? " |\(cityName.asStringOrEmpty())" : "" }
    var contactShipping: String { nameShipping + phoneShipping + addressShipping + cityShipping }
 
    enum CodingKeys: String, CodingKey {
        case id
        case cityId = "city_id"
        case wardId = "ward_id"
        case districtId = "district_id"
        case fullName = "full_name"
        case email1
        case address
        case state
        case phoneNumber = "phone_number"
        case isInfluencer = "is_influencer"
        case cityName = "city_name"
        case districtName = "district_name"
        case wardName = "ward_name"
    }
}
