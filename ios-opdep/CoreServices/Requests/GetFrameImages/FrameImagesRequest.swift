//
//  FrameImagesRequest.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/14/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit

struct FrameImagesRequest: RoutableRequest {
    public typealias Response = [DesignImageModel]
    public let route = "resources/masks/6"
}

struct DesignImageModel: Decodable {
    let id: Int64?
    let imageLink: String?
    let thumbLink: String?
    let categoryId: Int64?
    let info: String?
    
    enum CodingKeys: String, CodingKey {
    case id
    case imageLink = "image_url"
    case thumbLink = "image_thumb"
    case categoryId = "category_id"
    case info
    }
}

extension DesignImageModel: DesignContent {
    var url: URL? {
        guard let urlString = thumbLink else { return nil }
        return URL(string: urlString)
    }
}

extension DesignImageModel {
    var imageUrl: URL? {
        guard let urlString = imageLink, !isColor else { return nil }
        return URL(string: urlString)
    }
    
    var isColor: Bool {
        if let link = imageLink, link.prefix(1) == "#" {
            return true
        }
        return false
    }
    
    var color: UIColor? {
        if let link = imageLink, isColor {
            return UIColor(hexString: link)
        }
        return nil
    }
    
    var coloredImage: UIImage? {
        if let link = imageLink, isColor {
            return UIImage.imageWithColor(UIColor(hexString: link))
        }
        return nil
    }
}
