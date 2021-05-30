//
//  MultipartFormBuilder.swift

import Foundation
import Alamofire

public class MultipartFormBuilder<T: Uploadable> {
    public let formData: MultipartFormData
    public let request: T
    public init(request: T) {
        self.request = request
        formData = MultipartFormData(fileManager: .default,
                                     boundary: request.boundary)
    }
    
    @discardableResult
    public func build() -> MultipartFormData {
        let parameters = request.buildParameters()
        let fileDescriptors = request.buildFileDescriptors()
        parameters?.forEach {
            formData.append($0.value, withName: $0.key)
        }
        
        fileDescriptors?.forEach {
            formData.append($0.data,
                            withName: $0.fieldName,
                            fileName: $0.fileName,
                            mimeType: $0.mimeType.rawValue)
        }
        return formData
    }
}
