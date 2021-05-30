//
//  ShoppingCartRequest.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 11/05/2021.
//

import Foundation
import Alamofire

struct ShoppingCartRequest: RoutableRequest, EncodableRequest {
    public typealias Response = ShoppingCartResponse
    public let route = "shopCartInfo-v1"
    var body: ShoppingCartBodyRequest
    let method: HTTPMethod = .post
    init(userId: String) {
        body = ShoppingCartBodyRequest(userId: userId)
    }
}

struct ShoppingCartBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let user_id: String
    init(userId: String) {
        user_id = userId
    }
}

struct ShoppingCartResponse: Decodable {
    let status: Int
    let data: [ShoppingCart]?
    let deliveryInfo: [deliveryInfo]?
    let message: String
    
    var carts: [ShoppingCart] { data ?? [] }
    var shippingPrice: String {
        UtilityPrice.formatCurrency(currencyString: deliveryInfo?.first?.price ?? "0") }
}

struct ShoppingCart: Decodable {
    let id: Int
    let userId: Int
    let productId: Int
    let photoUrl: String
    let price: String
    let quantity: String
    let params: String?
    let createdAt: String?
    let updatedAt: String
    let name: String?
    let priceDiscount: String?
    let fullPhotoUrl: String?
    let photoUrlPreview: String?
    
    var imageProduct: URL? {
        guard let imageString = photoUrlPreview else { return nil }
        return URL(string: imageString)
    }
    
    var valueQuantity: String {
        "Số lượng: x\(quantity)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case productId = "product_id"
        case photoUrl = "photo_url"
        case price
        case quantity
        case params
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case name
        case priceDiscount = "price_discount"
        case fullPhotoUrl = "full_photo_url"
        case photoUrlPreview = "photo_url_preview"
    }
}

struct deliveryInfo: Decodable {
    let price: String
    var shippingPrice: String { UtilityPrice.formatCurrency(currencyString: price) }
}
