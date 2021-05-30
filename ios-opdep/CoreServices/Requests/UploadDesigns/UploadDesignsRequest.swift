//
//  UploadDesignsRequest.swift
//  OPOS
//
//  Created by Nguyen Hoc on 9/28/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import Alamofire

public struct UploadDesignsRequest: RoutableRequest, UploadableRequest {
    
    public typealias Response = UploadFilesResponse
    public let boundary: String? = nil
    public let body: UploadFilesBodyRequest
    public let route: String = "uploadDesign-v1-shop"
    public let method: HTTPMethod = .post
    
    init(userId: String,
         productId: Int64,
         photo: Data,
         preview: Data,
         print: Data) {
        body = UploadFilesBodyRequest(userId: userId,
                                      productId: productId,
                                      photo: photo,
                                      preview: preview,
                                      print: print)
    }
    
    public func buildParameters() -> [String: Data]? {
        var result: [String: Data] = [:]
        
        func stringify(_ value: Any?) -> String? {
            guard let value = value else { return nil }
            return "\(value)"
        }
        result["user_id"] = stringify(body.userId)?.asData
        result["product_id"] = stringify(body.productId)?.asData
        return result
    }
    
    public func buildFileDescriptors() -> [UploadFileDescriptor]? {
        return  [
            UploadFileDescriptor(fieldName: "photo",
                                 data: body.uploadPhoto,
                                 mimeType: .jpeg,
                                 fileName: "photo.pdf"),
            UploadFileDescriptor(fieldName: "preview",
                                 data: body.uploadPreview,
                                 mimeType: .jpeg,
                                 fileName: "preview.jpg"),
            UploadFileDescriptor(fieldName: "print",
                                 data: body.uploadPrint,
                                 mimeType: .jpeg,
                                 fileName: "print.pdf")
        ]
    }
}

public struct UploadFilesResponse: Decodable {
    let status: Int64
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}

public struct UploadFilesBodyRequest {
    let userId: String
    let productId: Int64
    let uploadPhoto: Data
    let uploadPreview: Data
    let uploadPrint: Data
    init(userId: String,
         productId: Int64,
         photo: Data,
         preview: Data,
         print: Data) {
        self.userId = userId
        self.productId = productId
        uploadPhoto = photo
        uploadPreview = preview
        uploadPrint = print
    }
}

struct OutPutFileModel {
    let preview: Data?
    let photo: Data?
    let print: Data?
}
