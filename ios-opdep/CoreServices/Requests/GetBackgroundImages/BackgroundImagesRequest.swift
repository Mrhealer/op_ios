//
//  BackgroundImagesRequest.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation

struct BackgroundCategoriesRequest: RoutableRequest {
    public typealias Response = [ImageCategoryModel]
    public let route = "resources/backgrounds"
}

struct ImageCategoryModel: Decodable {
    let id: Int64
    let title: String?
    let icon: String?
    let type: Int
    let items: [DesignImageModel]?
    public var images: [DesignImageModel] {
        items ?? []
    }
}

extension ImageCategoryModel: ImageCategoryContent {
    var url: URL? {
        guard let icon = icon else {
            return nil
        }
        return URL(string: icon)
    }
}
