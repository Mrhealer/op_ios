//
//  HeadersAdapter.swift

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    fileprivate let keyStore: KeyStore
    init(keyStore: KeyStore) {
        self.keyStore = keyStore
    }
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        defer {
            completion(.success(request))
        }
        
        guard let token = keyStore.accessToken else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}

final class MultipartInterceptor: BaseInterceptor {
    override func adapt(_ urlRequest: URLRequest,
                        for session: Session,
                        completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        defer {
            completion(.success(request))
        }
        
        guard let token = keyStore.accessToken else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
