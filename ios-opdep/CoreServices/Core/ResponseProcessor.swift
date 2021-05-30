//
//  ResponseProcessor.swift

import Foundation
import Alamofire

extension HTTPURLResponse {
    var isSuccessul: Bool {
        switch statusCode {
        case ..<400: return true
        default: return false
        }
    }
}

struct ResponseProcessor<T: CoreRequest> {
    let originalRequest: T
    let decoder: JSONDecoder
    init(request: T, decoder: JSONDecoder = JSONCustomDecoder.decoder) {
        self.originalRequest = request
        self.decoder = decoder
    }
    
    private func processAsDictionary(data: Data) throws -> T.Response? {
        let dictionary = try decoder.decode(APIService.DictionaryResponse<T>.self,
                                            from: data)
        return dictionary.data
    }
    
    private func processAsModel(data: Data) throws -> T.Response? {
        try decoder.decode(T.Response.self, from: data)
    }
        
    func process(data: Data) -> T.Response? {
        var errors: [Error] = []
        do {
            return try processAsModel(data: data)
        } catch {
            errors.append(error)
            
        }
        
        do {
            return try processAsDictionary(data: data)
        } catch {
            errors.append(error)
        }
        
        let errorMessages = errors.map {
            "\($0)"
        }.joined(separator: "\n")
        
        print("""
            "\(originalRequest) response proccessing failed: \(errorMessages)"
            """)
        return nil
    }
    
    func process(response: AFDataResponse<Any>,
                 completion: @escaping (Swift.Result<T.Response, APIError>) -> Void) {
        switch response.result {
        case let .failure(error):
            completion(.failure(.unexpected(error)))
            
        case let .success(result):
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 401:
                    completion(.failure(.unauthorized))
                case ..<500:
                    break
                default:
                    completion(.failure(.invalidRequest))
                }
            }
            guard let data = response.data else {
                if response.response?.isSuccessul == true {
                    completion(.failure(.emptyData(response.response)))
                } else {
                    completion(.failure(.invalidResponse))
                }
                return
            }

            if let object = process(data: data) {
                completion(.success(object))
                return
            }
            
            // Fallback to GenericResponse
            let json = result as? [String: Any]
            var status = response.response?.isSuccessul ?? false ? 0 : 1
            if let jsonStatus = json?["status"] as? Int {
                status = jsonStatus
            }

            let message = (json?["message"] as? String)
                ?? "There was an error with your request. Please try again"

            // Workaround for new endpoints without `success` field
            if T.Response.self == GenericResponse.self {
                let genericResponse = GenericResponse(status: status,
                                                      message: message)
                // swiftlint:disable force_cast
                completion(.success(genericResponse as! T.Response))
                return
            }

            completion(.failure(.serverError(message)))
            
        }
    }
}
