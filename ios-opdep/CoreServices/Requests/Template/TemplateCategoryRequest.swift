//
//  TemplateCategoryRequest.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 6/4/21.
//

import Foundation
import Alamofire


struct TemplateCategoryRequest:RoutableRequest, EncodableRequest {
    public typealias Response = TemplateCategory
    public let route = "category/template/item"
    var body: TemplateCategoryBodyRequest
    let method: HTTPMethod = .get
    init(categoryId: String) {
        body = TemplateCategoryBodyRequest(categoryId: categoryId)
    }
}

struct TemplateCategoryBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let category_id: String
    init(categoryId: String) {
        category_id = categoryId
    }
}

// MARK: - Welcome
struct TemplateCategory: Decodable {
    let status: Int
    let data: [TemplateCategoryData]
    let message: String
}

// MARK: - Datum
struct TemplateCategoryData: Decodable {
    let id, categoryID: Int
    let imageURL: String
    let context: String
    let orderDisplay: JSONNull?
    let createdAt, updatedAt: String
    let used: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case imageURL = "image_url"
        case context
        case orderDisplay = "order_display"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case used
    }
}
