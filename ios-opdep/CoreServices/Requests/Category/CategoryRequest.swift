//
//  CategoryRequest.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 01/05/2021.
//

import Foundation
import Alamofire

struct CategoryRequest: RoutableRequest {
    public typealias Response = [Categories]
    public let route = "get-phone-model"
    public let method: HTTPMethod = .post
}

struct CategoryResponse: Decodable {
    let status: Int
    let data: [Categories]
    let message: String?
}

struct Categories: Decodable {
    let id: Int
    let name: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
    }
}
