//
//  CategoryBarItemViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

enum CategoryType {
    case user
    case template
}

class CategoryBarItemViewModel {
    let type: CategoryType
    let model: Property<ImageCategoryModel>
    let isSelected: MutableProperty<Bool>
    
    init(type: CategoryType, model: ImageCategoryModel, isSelected: Bool = false) {
        self.type = type
        self.model = Property(value: model)
        self.isSelected = MutableProperty(isSelected)
    }
}
