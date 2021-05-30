//
//  RequestBuilder.swift

import Foundation
import Alamofire

struct RequestBuilder<T: CoreRequest>: URLRequestConvertible {
    let request: T
    let interceptor: RequestInterceptor?
    
    init(request: T, keyStore: KeyStore) {
        self.request = request
        // input thông tin header tuỳ các request
        self.interceptor = {
            return BaseInterceptor(keyStore: keyStore)
        }()
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
