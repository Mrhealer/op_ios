//
//  DownloadableRequest.swift

import Foundation

public protocol DownloadableRequest: RoutableRequest { }

extension DownloadableRequest {
    var url: URL! {
        guard let url = URL(string: route) else {
            fatalError("Incorrect url for \(route)")
        }
        return url
    }
}
