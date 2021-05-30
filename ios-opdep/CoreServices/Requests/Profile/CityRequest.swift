//
//  CityRequest.swift
//  OPOS
//
//  Created by Nguyễn Quang on 10/7/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import Alamofire
// MARK: CityRequest
struct CityRequest: RoutableRequest {
    public typealias Response = CityResponse
    public let route = "v2/city"
    let method: HTTPMethod = .get
}

struct CityResponse: Decodable {
    let status: Int64
    let data: [Cities]?
    let message: String?
    var cities: [Cities] { data ?? [] }
}

struct Cities: Decodable {
    let id: Int
    let name: String?
    let type: String?
}
