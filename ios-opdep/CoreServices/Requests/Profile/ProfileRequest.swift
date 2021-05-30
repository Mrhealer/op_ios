//
//  ProfileRequest.swift
//  Customdat
//
//  Created by Nguyễn Quang on 8/28/20.
//  Copyright © 2020 Nguyen Hoc. All rights reserved.
//

import Foundation
import Alamofire

struct ProfileRequest: RoutableRequest, EncodableRequest {
    public typealias Response = Profile
    public let route = "v2/showProfile"
    var body: ProfileBodyRequest
    let method: HTTPMethod = .post
    init(userId: String) {
        body = ProfileBodyRequest(userId: userId)
    }
}

struct ProfileBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let user_id: String
    init(userId: String) {
        user_id = userId
    }
}

struct ProfileData {
    let title: String
    let dec: String
    let placehoder: String
    
    init(title: String,
         dec: String,
         placehoder: String) {
        self.title = title
        self.dec = dec
        self.placehoder = placehoder
    }
}

enum ProfileItem {
    case fullName
    case phoneNumber
    case address
    
    var title: String {
        switch self {
        case .fullName        : return "Họ và tên"
        case .phoneNumber     : return "Số điện thoại"
        case .address         : return "Số nhà, đường phố"
        }
    }
    var model: ProfileItemModel { .init(profile: self) }
}
struct ProfileItemModel {
    let profile: ProfileItem
}
