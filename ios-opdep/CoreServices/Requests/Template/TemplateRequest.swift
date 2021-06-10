//
//  TemplateRequest.swift
//  ios-opdep
//
//  Created by Healer on 03/06/2021.
//

import Foundation

import Alamofire

struct TemplateRequest:RoutableRequest {
    public typealias Response = PurpleData
    public let route = "v2/home"
    let method: HTTPMethod = .get
}

struct PhoneTemplateRequest:RoutableRequest {
    public typealias Response = PhoneData
    public let route = "get-phone-model"
    let method: HTTPMethod = .post
}

struct PhoneListRequest:RoutableRequest, EncodableRequest {
    public typealias Response = PhoneListData
    public let route = "get-product"
    var body: TemplateCategoryBodyRequest
    let method: HTTPMethod = .post
    init(categoryId: String) {
        body = TemplateCategoryBodyRequest(categoryId: categoryId)
    }
}

struct PhoneData: Decodable {
    let status: Int
    let message: String
    let data: [PhoneTemplateData]?
}

struct PhoneListData: Decodable {
    let status: Int
    let message: String
    let data: [PhoneListTemplateData]?
}

struct PhoneTemplateData: Decodable {
    let id: Int
    let imageURL: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case name
    }
}

struct PhoneListTemplateData: Decodable {
    let id: Int
    let editor: [ProductModel.EditorItem]
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case editor
        case name
    }
}

// MARK: - PurpleData
struct PurpleData: Decodable {
    let status: Int
    let message: String
    let data: [Template]?
    var template: [Template] { data ?? [] }
}

// MARK: - Datum
struct Template: Decodable {
    let name: String
    let layout: Int
    let content: [Content]
}

// MARK: - Content
struct Content: Decodable {
    let category: Category?
    let type: Int?
    let template: ContentTemplate?
}

// MARK: - Category
struct Category: Decodable {
    let id: Int
    let name: String
    let imageURL: String?
    let categoryDescription: String?
    let parentID, used: JSONNull?
    let createdAt, updatedAt: String?
    let orderDisplay: JSONNull?
    let nameFolder: String?
//    let template: TemplateUnion?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case categoryDescription = "description"
        case parentID = "parent_id"
        case used
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case orderDisplay = "order_display"
        case nameFolder = "name_folder"
//        case template
    }
}

enum TemplateUnion: Codable {
    case templateElementArray([TemplateElement])
    case templateElementMap([String: TemplateElement])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([TemplateElement].self) {
            self = .templateElementArray(x)
            return
        }
        if let x = try? container.decode([String: TemplateElement].self) {
            self = .templateElementMap(x)
            return
        }
        throw DecodingError.typeMismatch(TemplateUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TemplateUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .templateElementArray(let x):
            try container.encode(x)
        case .templateElementMap(let x):
            try container.encode(x)
        }
    }
}

// MARK: - TemplateElement
struct TemplateElement: Codable {
    let template: ContentTemplate
}

// MARK: - ContentTemplate
struct ContentTemplate: Codable {
    let id, categoryID: Int
    let imageURL: String
    let context: String?
    let orderDisplay: JSONNull?
    let createdAt, updatedAt: String
    let used: JSONNull?
    let imgThumb: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case imageURL = "image_url"
        case context
        case orderDisplay = "order_display"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case used
        case imgThumb = "img_thumb"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
