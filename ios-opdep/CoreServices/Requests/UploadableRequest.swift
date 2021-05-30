//
//  UploadableRequest.swift

import Foundation
import Alamofire

public protocol Uploadable {
    var boundary: String? { get }
    func buildParameters() -> [String: Data]?
    func buildFileDescriptors() -> [UploadFileDescriptor]?
}

public typealias UploadableRequest = CoreRequest & Uploadable

public extension CoreRequest where Self: Uploadable {
    var method: HTTPMethod { .post }
}

public struct UploadFileDescriptor {
    public enum MimeType: String {
        case mp4 = "video/mp4"
        case jpeg = "image/png"
        case pdf = "application/pdf"
        public var defaultFileName: String {
            switch self {
            case .mp4:
                return "video.mp4"
            case .jpeg:
                return "image/png"
            case .pdf:
                return "print.pdf"
            }
        }
    }
    
    public let data: Data
    public let fileName: String
    public let mimeType: MimeType
    public let fieldName: String
    public init(fieldName: String,
                data: Data,
                mimeType: MimeType,
                fileName: String? = nil) {
        self.fieldName = fieldName
        self.data = data
        self.mimeType = mimeType
        self.fileName = fileName ?? mimeType.defaultFileName
    }
}
