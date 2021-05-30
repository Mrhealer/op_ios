//
//  RoutableRequest.swift

import Foundation

public protocol RoutableRequest: CoreRequest {
    var route: String { get }
}

public extension RoutableRequest {
    var url: URL! {
        guard var url = URL(string: APIService.shared.environment.serverURL) else {
            fatalError("Incorrect url for \(route)")
        }
        url.appendPathComponent(route)
        return url
    }
}
