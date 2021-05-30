//
//  File.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 03/05/2021.
//

import Foundation
import Alamofire

struct ProductVariantsRequest: RoutableRequest, EncodableRequest {
    public typealias Response = [ProductModel]
    public let route = "get-product"
    var body: ProductVariantsBodyRequest
    let method: HTTPMethod = .post
    init(categoryId: String) {
        body = ProductVariantsBodyRequest(categoryId: categoryId)
    }
}

struct ProductVariantsBodyRequest: Encodable {
    // swiftlint:disable identifier_name
    let category_id: String
    init(categoryId: String) {
        category_id = categoryId
    }
}

struct ProductVariantsResponse: Decodable {
    let status: Int
    let products: [ProductModel]
    let message: String
}

struct ProductModel: Storable {
    let id: Int64
    let name: String?
    let imgUrl: String?
    let price: String?
    let priceDiscount: String?
    var layerWidth: Int { 1024 }
    var layerHeight: Int { 2732 }
    var phoneTopPosition: Int { 300 }
    var phoneWidth: Int { 996 }
    var phoneHeight: Int { 1944 }
    let editor: [EditorItem]?
    
    struct EditorItem: Codable {
        let image: String?
        let order: Int?
    }
    
    enum CodingKeys: String, CodingKey {
    case id
    case name
    case imgUrl = "img_url"
    case price
    case priceDiscount = "price_discount"
    case editor
    }
}

extension ProductModel {
//    var imageUrl: URL? {
//        guard let link = phoneCaseType.imageLink else { return nil }
//        return URL(string: link)
//    }
    
    func frameDesign(with screenSize: CGSize) -> CGRect {
        // scale theo ti le chieu cao giua chieu cao man hinh va chieu cao cua thiet ke
        let scale = screenSize.height / CGFloat(layerHeight)
        let y = Int(CGFloat(phoneTopPosition) * scale)
        let height = Int(CGFloat(phoneHeight) * scale)
        let width = Int(CGFloat(phoneWidth) * scale)
        let x = Int((screenSize.width - CGFloat(width)) / 2)
        return CGRect(x: x,
                      y: y,
                      width: width,
                      height: height)
    }
    
    func backgroundLayerWidth(with screenSize: CGSize) -> Int {
        let scale = screenSize.height / CGFloat(layerHeight)
        return Int(CGFloat(layerWidth) * scale)
    }
    
    var backLayerImageUrl: URL? {
        guard let editor = editor, !editor.isEmpty else { return nil }
        let backEditor = editor[0]
        guard let imageString = backEditor.image else { return nil }
//        return URL(string: imageString.escape())
        return URL(string: imageString)
    }
    
    var middleLayerImageUrl: URL? {
        guard let editor = editor, editor.count > 1 else { return nil }
        let middleEditor = editor[1]
        guard let imageString = middleEditor.image else { return nil }
//        return URL(string: imageString.escape())
        return URL(string: imageString)
    }
    
    var frontLayerImageUrl: URL? {
        guard let editor = editor, editor.count > 2 else { return nil }
        let frontEditor = editor[2]
        guard let imageString = frontEditor.image else { return nil }
//        return URL(string: imageString.escape())
        return URL(string: imageString)
    }
}
