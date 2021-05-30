//
//  APIErrors.swift

import Foundation

protocol WrappableError: Error {
    static func wrap(_ error: Error) -> Self
}

// Định nghĩa các error từ API

enum APIError: LocalizedError {
    case invalidRequest
    case invalidResponse
    case serverError(String)
    case unexpected(Error)
    case emptyData(HTTPURLResponse?)
    case unauthorized
}

extension APIError {
    var errorDescription: String? {
        switch self {
        case let .serverError(reason):
            return reason
        case .unauthorized:
            return "Phiên của bạn đã hết hạn!"
        case .invalidResponse,
             .invalidRequest,
             .unexpected,
             .emptyData:
            return "Oops! Đã xảy ra lỗi. Chúng tôi không thể hoàn thành yêu cầu của bạn"
        }
    }
}

// convert 1 error bất kỳ thành APIError
extension APIError: WrappableError {
    static func wrap(_ error: Error) -> APIError {
        guard let apiError = error as? APIError else {
            return .unexpected(error)
        }
        return apiError
    }
}
