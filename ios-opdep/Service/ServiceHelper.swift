//
//  ServiceHelper.swift
//  VoiceApp
//
//  Created by VMO on 3/29/20
//  Copyright © 2020 VoiceApp. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

struct ServiceHelper {
    static let errorServiceDomain = "com.vmodev.error.service"
    static let errorMoyaDomain = "Moya.MoyaError"
    static let errorCodeUnauthenticated = 401
    static let errorCodeUnauthorized = 403
    static let errorCodeGatewayTimeOut = 504
    static let errorCodeInvalidData = 422
}

extension NSError {
    
    var isUnauthenticated: Bool {
        return self.code == ServiceHelper.errorCodeUnauthenticated
    }
    
    var isUnauthorized: Bool {
        return self.code == ServiceHelper.errorCodeUnauthorized
    }
    
    var isGatewayTimeOut: Bool {
        return self.code == ServiceHelper.errorCodeGatewayTimeOut
    }
    
    var isMoyaError: Bool {
        return self.domain == ServiceHelper.errorMoyaDomain
    }
}

extension Moya.Response {
    
    var isSuccess: Bool {
        return statusCode / 100 == 2
    }
    
    var isUnauthenticated: Bool {
        return statusCode == ServiceHelper.errorCodeUnauthenticated
    }
    
    var isUnauthorized: Bool {
        return statusCode == ServiceHelper.errorCodeUnauthorized
    }
    
    var isGatewayTimeOut: Bool {
        return statusCode == ServiceHelper.errorCodeGatewayTimeOut
    }
    
    var isInvalidData: Bool {
        return statusCode == ServiceHelper.errorCodeInvalidData
    }
    
}
