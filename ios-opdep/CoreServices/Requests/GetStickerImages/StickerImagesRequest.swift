//
//  StickerImagesRequest.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation

struct StickerImagesRequest: RoutableRequest {
    public typealias Response = [ImageCategoryModel]
    public let route = "resources/patterns"
}
