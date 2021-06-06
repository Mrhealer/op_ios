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
    case deleteOrder(params: [String: Any])
}

extension HomeApi: TargetType {
    
    public var baseURL: URL {
        return URL(string: APIService.shared.environment.serverURL)!
    }
    
    public var path: String {
        switch self {
        case .deleteOrder:
            return "shopCartInfo/delete"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .deleteOrder:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .deleteOrder(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": APIService.shared.keyStore.accessToken.asStringOrEmpty()]
    }
}
