//
//  Request.swift

import Foundation
import Alamofire

// MARK: -
public protocol CoreRequest {
    associatedtype Response: Decodable
    var method: HTTPMethod { get }
    var url: URL! { get }
    var bodyData: Data? { get }
    var encoding: ParameterEncoding { get }
    var isMultipart: Bool { get }
}

public extension CoreRequest {
    var method: HTTPMethod { .get }
    var bodyData: Data? { nil }
    var encoding: ParameterEncoding {
        switch method {
        case .post, .put, .patch:
            return JSONEncoding.default
        default:
            return URLEncoding(destination: .queryString,
                               arrayEncoding: .noBrackets,
                               boolEncoding: .literal)
        }
    }
    var isMultipart: Bool { false }
}

// MARK: -
public protocol EncodableRequest: CoreRequest, Encodable {
    
    associatedtype Body: Encodable
    var body: Body { get }
}

public extension EncodableRequest {
    
    func encode(to encoder: Encoder) throws {
        try body.encode(to: encoder)
    }
    
    var bodyData: Data? {
        try? JSONCustomDecoder.encoder.encode(body)
    }
}

// MARK: -

public protocol MultipartRequest: CoreRequest {
    associatedtype AdditionalParameters: Encodable
    
    var mediaName: String { get }
    var mediaMimeType: String { get }
    var fileName: String { get }
    var params: [String: Data]? { get }
}

extension MultipartRequest {
    public var method: HTTPMethod { .post }
    public var isMultipart: Bool { true }
}
