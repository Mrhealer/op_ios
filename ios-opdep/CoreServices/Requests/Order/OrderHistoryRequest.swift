//
//  OrderHistoryRequest.swift
//  OPOS
//
//  Created by Hoc Nguyen on 7/17/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import Alamofire

struct OrderHistoryRequest: RoutableRequest, EncodableRequest {
    public typealias Response = [OrderHistoryResponse]
    public let route = "order-history"
    var body: OrderHistoryBodyRequest
    let method: HTTPMethod = .post
    init(userId: String) {
        body = OrderHistoryBodyRequest(userId: userId)
    }
}

struct OrderHistoryBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let user_id: String
    init(userId: String) {
        user_id = userId
    }
}

struct OrderHistoryResponse: Decodable {
    let webhookResult: String?  
    let timeDeliveryOption: Int?
    let doorbellWork: Int?
    let createdAt: String?
    let id: Int?
    let paymentOption: Int?
    let country: String?
    let customerAddress: String?
    let state: String?
    let district: String?
    let ward: String?
    let updatedBy: Int?
    let dateUpdated: String?
    let statusGood: Int?
    let countryId: Int?
    let streetNumber: String?
    let statusText: String?
    let totalTtem: Int?
    let addressFull: String?
    let flat: String?
    let osType: Int?
    let orderNumber: String?
    let estimateDeliveryText: String?
    let statusWarring: Int?
    let shippingType: Int?
    let zip: String?
    let status: Int?
    let customerEmail: String?
    let city: String?
    let extraInfor: String?
    let shippingId: Int?
    let shippingPrice: Float?
    let date: String?
    let door: String?
    let userId: Int?
    let customerPhone: String?
    let updatedAt: String?
    let trackingNumber: String?
    let totalPrice: String?
    let customerName: String?
    let cashOnDeliveryPrice: Int?
    let isApartment: Int?
    let note: String?
    let typeTracking: String?
    let statusDanger: Int?
    let details: [OrderDetailDataResponse]?
    
    var orderHistoryNumber: String { "Mã đơn hàng: \(orderNumber.asStringOrEmpty())" }
    var orderStatusText: String { statusText.asStringOrEmpty() }
    var dateCreateOrder: String { "Ngày đặt hàng: \(date.asStringOrEmpty())" }
    var totalPriceOrder: String {
        "Thành tiền: \(UtilityPrice.formatCurrency(currencyString: totalPrice.asIntOrEmpty()))"
    }
        
    enum CodingKeys: String, CodingKey {
        case webhookResult = "webhook_result"
        case timeDeliveryOption = "time_delivery_option"
        case doorbellWork = "doorbell_work"
        case createdAt = "created_at"
        case id
        case paymentOption = "payment_option"
        case country
        case customerAddress = "customer_address"
        case state
        case district
        case ward
        case updatedBy = "updated_by"
        case dateUpdated = "date_updated"
        case statusGood = "status_good"
        case countryId = "country_id"
        case streetNumber = "street_number"
        case statusText = "status_text"
        case totalTtem = "total_item"
        case addressFull = "address_full"
        case flat
        case osType = "os_type"
        case orderNumber = "order_number"
        case estimateDeliveryText = "estimate_delivery_text"
        case statusWarring = "status_warring"
        case shippingType = "shipping_type"
        case zip
        case status
        case customerEmail = "customer_email"
        case city
        case extraInfor = "extra_infor"
        case shippingId = "shipping_id"
        case shippingPrice = "shipping_price"
        case date
        case door
        case userId = "user_id"
        case customerPhone = "customer_phone"
        case updatedAt = "updated_at"
        case trackingNumber = "tracking_number"
        case totalPrice = "total_price"
        case customerName = "customer_name"
        case cashOnDeliveryPrice = "cash_on_delivery_price"
        case isApartment = "is_apartment"
        case note
        case typeTracking = "type_tracking"
        case statusDanger = "status_danger"
        case details
    }
}

struct OrderDetailDataResponse: Decodable {
    let id: Int64
    let orderId: Int64?
    let userId: String?
    let productId: Int64?
    let photoUrl: String?
    let price: String?
    let quantity: String?
    let params: String?
    let fullPhotoUrl: String?
    let photoUrlPreview: String?
    let product: ProductResponse?
    let createdAt: String?
    let updatedAt: String?
    let order: OrderMetaData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderId = "order_id"
        case userId = "user_id"
        case productId = "product_id"
        case photoUrl = "photo_url"
        case price
        case quantity
        case params
        case fullPhotoUrl = "full_photo_url"
        case photoUrlPreview = "photo_url_preview"
        case product
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case order
    }
}

struct OrderMetaData: Decodable {
    let status: Int?
    let id: Int?
    let userId: Int?
    let totalPrice: String?
    let shippingPrice: Int?
    let cashOnDeliveryPrice: Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case id
        case userId = "user_id"
        case totalPrice = "total_price"
        case shippingPrice = "shipping_price"
        case cashOnDeliveryPrice = "cash_on_delivery_price"
    }
}

struct ProductResponse: Decodable {
    let id: Int64?
    let name: String?
    let title: String?
    let description: String?
    let imgUrl: String?
    let price: String?
    let priceDiscount: String?
    let currencyDisplay: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case description
        case imgUrl = "img_url"
        case price
        case priceDiscount = "price_discount"
        case currencyDisplay = "currency_display"
    }
}

extension OrderDetailDataResponse {
    var imageProduct: URL? {
        guard let logo = photoUrlPreview else {
            return nil
        }
        return URL(string: logo)
    }
}
