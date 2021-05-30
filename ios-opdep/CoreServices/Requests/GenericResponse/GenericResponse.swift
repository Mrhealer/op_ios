//
//  GenericResponse.swift
import Foundation

public struct GenericResponse: Decodable {
    let status: Int
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
    
    init(status: Int, message: String?) {
        self.status = status
        self.message = message
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? container.decode(Int.self, forKey: .status)) ?? 1
        message = try? container.decode(String.self, forKey: .message)
    }
}
