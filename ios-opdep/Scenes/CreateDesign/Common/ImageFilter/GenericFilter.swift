//
//  GenericFilter.swift
//  OPOS
//
//  Created by Tran Van Dinh on 8/1/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import GPUImage

enum FilterOperationType {
    // Trong pj này t chỉ đơn giản với đầu vào là image cần filter và output là image được filter
    case singleInput
//    case Blend
//    case Custom
}

// Định nghĩa thông tin về bộ filter
protocol FilterOperationProtocol {
    var outputFilter: GPUImageOutput { get }
    var filterName: String { get }
    var thumbnailName: String? { get }
    var filterOperationType: FilterOperationType { get }
    func updateFilterValue(value: Float)
}

class FilterOperation <T: GPUImageOutput>: FilterOperationProtocol where T: GPUImageInput {
    let filter: T
    let filterName: String
    let thumbnailName: String?
    let filterOperationType: FilterOperationType = .singleInput
    var updateValue: ((_ filter: T, _ value: Float) -> Void)?
    
    init(filterName: String,
         thumbnailName: String?,
         updateValue: ((_ filter: T, _ value: Float) -> Void)?) {
        filter = T()
        self.filterName = filterName
        self.thumbnailName = thumbnailName
        self.updateValue = updateValue
    }
    
    func updateFilterValue(value: Float) {
        if let update = updateValue {
            update(filter, value)
        }
    }
    
    var outputFilter: GPUImageOutput { filter }
}
