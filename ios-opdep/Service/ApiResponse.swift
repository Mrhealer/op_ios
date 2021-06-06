//
//  ApiResponse.swift
//  VoiceApp
//
//  Created by VMO on 3/29/20
//  Copyright © 2020 VoiceApp. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya

public class ApiResponse {
    
    let error: NSError?
    let jsonData: JSON?
    let statusCode: Int?
    let status: Int?
    let message: String?
    
    var isSuccess: Bool {
        return status == 200
    }
    
    required init(response: Response) {
        // Success case
        statusCode = response.statusCode
        let json = JSON(response.data)
        status = json["status"].intValue
        message = json["message"].stringValue
        if response.isSuccess {
            if status == 200 {
                 self.error = nil
            } else {
                let code = json["status"].intValue
                self.error = NSError(
                    domain: ServiceHelper.errorServiceDomain,
                    code: code,
                    userInfo: [NSLocalizedDescriptionKey: message ?? "error"])
            }
            let jsonData = json
            if jsonData.exists() {
                self.jsonData = jsonData
                self.parsingData(json: jsonData)
            } else {
                self.jsonData = json
            }
            return
        }
        
        // Error cases
        if response.isUnauthenticated {
            self.error = NSError(
                domain: ServiceHelper.errorServiceDomain,
                code: ServiceHelper.errorCodeUnauthorized,
                userInfo: [NSLocalizedDescriptionKey: "error"])
            self.jsonData = nil
            return
        } else if response.isGatewayTimeOut {
            self.error = NSError(
                domain: ServiceHelper.errorServiceDomain,
                code: ServiceHelper.errorCodeGatewayTimeOut,
                userInfo: [NSLocalizedDescriptionKey: "error"])
            self.jsonData = nil
            return
        }
        
        let messageJson = JSON(response.data)["message"]
        if messageJson.exists() {
            self.error = NSError(
                domain: ServiceHelper.errorServiceDomain,
                code: response.statusCode,
                userInfo: [NSLocalizedDescriptionKey: messageJson.stringValue])
            self.jsonData = nil
            return
        } else {
            self.error = NSError(
                domain: ServiceHelper.errorServiceDomain,
                code: response.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "error"])
            self.jsonData = nil
        }
    }
    
    required init(error: Error) {
        let nsError = error as NSError
        
        self.error = NSError(
            domain: nsError.domain,
            code: nsError.code,
            userInfo: [NSLocalizedDescriptionKey: nsError.localizedDescription])
        self.jsonData = nil
        self.status = nil
        self.statusCode = nsError.code
        self.message = nsError.localizedDescription
    }
    
    // Override to parsing data
    func parsingData(json: JSON) {
        
    }
    
}
