//
//  APIService+Utils.swift

import ReactiveSwift
import Combine

// MARK: - Reactive extension
extension APIService: ReactiveExtensionsProvider {}

extension Reactive where Base: APIService {
    func response<T: CoreRequest>(of request: T) -> SignalProducer<T.Response, APIError> {
        SignalProducer { [weak base, request] observer, _ in
            guard let sbase = base else {
                observer.sendCompleted()
                return
            }
            
            sbase.send(request: request) { result in
                switch result {
                case let .success(value):
                    observer.send(value: value)
                    observer.sendCompleted()
                    
                case let .failure(error):
                    guard let handler = base?.errorHandler else {
                        observer.send(error: error)
                        return
                    }

                    handler.processAPIError(error)
                        ? observer.send(error: error)
                        : observer.sendCompleted()
                }
            }
        }
    }
    
    func response<T: UploadableRequest>(of request: T) -> SignalProducer<T.Response, APIError> {
        SignalProducer { [weak base, request] observer, _ in
            guard let sbase = base else {
                observer.sendCompleted()
                return
            }
            
            sbase.send(request: request) { result in
                switch result {
                case let .success(value):
                    observer.send(value: value)
                    observer.sendCompleted()
                    
                case let .failure(error):
                    guard let handler = base?.errorHandler else {
                        observer.send(error: error)
                        return
                    }

                    handler.processAPIError(error)
                        ? observer.send(error: error)
                        : observer.sendCompleted()
                }
            }
        }
    }
    
    func response<T: DownloadableRequest>(of request: T) -> SignalProducer<T.Response, APIError> {
        SignalProducer { [weak base, request] observer, _ in
            guard let sbase = base else {
                observer.sendCompleted()
                return
            }
            
            sbase.send(request: request) { result in
                switch result {
                case let .success(value):
                    observer.send(value: value)
                    observer.sendCompleted()
                    
                case let .failure(error):
                    guard let handler = base?.errorHandler else {
                        observer.send(error: error)
                        return
                    }

                    handler.processAPIError(error)
                        ? observer.send(error: error)
                        : observer.sendCompleted()
                }
            }
        }
    }
}

// Case 1: Use Future
// Case 2: Use custome publisher ??
// MARK: - Combine extension: Use Future
@available(iOS 13.0, *)
extension APIService {
    func response<T: CoreRequest>(of request: T) -> AnyPublisher<T.Response, APIError> {
        Future<T.Response, APIError> { [weak self] promise in
            guard let sself = self else { return promise(.failure(.invalidRequest))}
            sself.send(request: request) { result in
                switch result {
                case let .success(value):
                    promise(.success(value))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func response<T: UploadableRequest>(of request: T) -> AnyPublisher<T.Response, APIError> {
        Future<T.Response, APIError> { [weak self] promise in
            guard let sself = self else { return promise(.failure(.invalidRequest))}
            sself.send(request: request) { result in
                switch result {
                case let .success(value):
                    promise(.success(value))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func response<T: DownloadableRequest>(of request: T) -> AnyPublisher<T.Response, APIError> {
        Future<T.Response, APIError> { [weak self] promise in
            guard let sself = self else { return promise(.failure(.invalidRequest))}
            sself.send(request: request) { result in
                switch result {
                case let .success(value):
                    promise(.success(value))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
