//
//  CoreServices.swift

import Foundation
import Alamofire

final class APIService {
    
    public private(set) static var shared: APIService!
    public private(set) var keyStore: KeyStore
    public private(set) var environment: Environment
    let errorHandler: APIErrorCatchable?
    
    let session: Session

    private init(environment: Environment,
                 keyStore: KeyStore,
                 errorHandler: APIErrorCatchable? = nil) {
        self.environment = environment
        self.keyStore = keyStore
        self.errorHandler = errorHandler
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        session = Session(configuration: configuration)
        print("⚠️ Using environment \(environment.description)")
    }
    
    class func set(environment: Environment,
                   keyStore: KeyStore,
                   errorHandler: APIErrorCatchable? = nil) {
        self.shared = APIService(environment: environment,
                                 keyStore: keyStore,
                                 errorHandler: errorHandler)
    }

    func send<T: CoreRequest>(request: T,
                              completion: @escaping (Result<T.Response, APIError>) -> Void) {
        let builder = RequestBuilder(request: request,
                                     keyStore: keyStore)
        session.request(builder, interceptor: builder.interceptor)
            .responseJSON { [request] response in
                let processor = ResponseProcessor(request: request)
                processor.process(response: response) { result in
                    completion(result)
                }
        }
    }
    
    func send<T: UploadableRequest>(request: T,
                                    completion: @escaping (Result<T.Response, APIError>) -> Void) {
        let formData = MultipartFormBuilder(request: request).build()
        session.upload(multipartFormData: formData,
                       to: request.url,
                       interceptor: MultipartInterceptor(keyStore: keyStore))
            .responseJSON { [request] response in
                let processor = ResponseProcessor(request: request)
                processor.process(response: response) { result in
                    completion(result)
                }
        }
    }
    
    func send<T: DownloadableRequest>(request: T,
                                      completion: @escaping (Result<T.Response, APIError>) -> Void) {
        let builder = DownloadBuilder(request: request,
                                     keyStore: keyStore)
        session.download(builder,
                         interceptor: builder.interceptor,
                         to: builder.destination).response { response in
                            if T.Response.self != DownloadedFileModel.self {
                                completion(.failure(.serverError("There was an error with your request. Please try again")))
                                return
                            }
                            var path: String?
                            if response.error == nil,
                                let filePath = response.fileURL?.path {
                                path = filePath
                            }
                            // swiftlint:disable force_cast
                            completion(.success(DownloadedFileModel(filePath: path) as! T.Response))
        }

    }

    // MARK: - Security
    public func clearToken() {
        keyStore.setAccessToken(nil)
    }
}

extension APIService {
    struct DictionaryResponse<T: CoreRequest>: Decodable {
        let data: T.Response
    }
}

extension APIService {
    public func serverURL() -> String {
        environment.serverURL
    }
}
