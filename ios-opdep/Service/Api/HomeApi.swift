//
//  HomeApi.swift
//  VoiceApp
//
//  Created by VMO on 12/10/20.
//  Copyright © 2020 VoiceApp. All rights reserved.
//

import Foundation
import Moya

public enum HomeApi {
    case cancelOrder(params: [String: Any])
}

extension HomeApi: TargetType {
    
    public var baseURL: URL {
        return URL(string: APIService.shared.environment.serverURL)!
    }
    
    public var path: String {
        switch self {
        case .cancelOrder:
            return "order/cancel"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .cancelOrder:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .cancelOrder(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": APIService.shared.keyStore.accessToken.asStringOrEmpty()]
    }
}
