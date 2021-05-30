//
//  FontImagesRequest.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/15/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation

struct FontImagesRequest: RoutableRequest {
    public typealias Response = [DesignImageModel]
    public let route = "resources/fonts"
}
