//
//  DownloadBuilder.swift

import Foundation
import Alamofire

struct DownloadBuilder<T: DownloadableRequest>: URLRequestConvertible {
    let request: T
    let destination: DownloadRequest.Destination
    let interceptor: RequestInterceptor?
    
    init(request: T, keyStore: KeyStore) {
        self.request = request
        self.interceptor = {
            return BaseInterceptor(keyStore: keyStore)
        }()
        self.destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(request.url.lastPathComponent)

            return (fileURL, [.removePreviousFile,
                              .createIntermediateDirectories])
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlRequest = try URLRequest(url: request.url, method: request.method)
        var parameters: Parameters?
        if let data = request.bodyData,
            let params = try JSONSerialization.jsonObject(with: data, options: []) as? Parameters {
            parameters = params
        }
        
        return try request.encoding.encode(urlRequest, with: parameters)
    }
}
