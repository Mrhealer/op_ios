//
//  DownloadFontRequest.swift
//  OPOS
//
//  Created by Tran Van Dinh on 8/3/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import Alamofire

struct DownloadFontRequest: DownloadableRequest {
    public typealias Response = DownloadedFileModel
    let route: String
    init(route: String) {
        self.route = route
    }
}
