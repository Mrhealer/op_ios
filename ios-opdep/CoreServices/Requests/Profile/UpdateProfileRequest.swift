//
//  UpdateProfileRequest.swift
//  Customdat
//
//  Created by Nguyễn Quang on 9/1/20.
//  Copyright © 2020 Nguyen Hoc. All rights reserved.
//

import Foundation
import Alamofire

struct UpdateProfileRequest: RoutableRequest, EncodableRequest {
    public typealias Response = UpdateProfileResponse
    public let route = "v2/updateProfile"
    var body: UpdateProfileBodyRequest
    let method: HTTPMethod = .post
    init(userId: String,
         fullName: String,
         email: String = "",
         phoneNumber: String,
         address: String,
         cityId: String) {
        body = UpdateProfileBodyRequest(userId: userId,
                                        fullName: fullName,
                                        email: email,
                                        phoneNumber: phoneNumber,
                                        address: address,
                                        cityId: cityId)
    }
}

struct UpdateProfileBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let user_id: String
    let full_name: String
    let email: String
    let phone_number: String
    let address: String
    let city_id: String
    init(userId: String,
         fullName: String,
         email: String,
         phoneNumber: String,
         address: String,
         cityId: String) {
        user_id = userId
        full_name = fullName
        self.email = email
        phone_number = phoneNumber
        self.address = address
        self.city_id = cityId
    }
}

struct UpdateProfileResponse: Decodable {
    let status: Int64
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
