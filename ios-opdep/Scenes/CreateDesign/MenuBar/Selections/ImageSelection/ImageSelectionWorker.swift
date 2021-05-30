//
//  ImageSelectionWorker.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/20/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class ImageSelectionWorker {
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchCategories() -> SignalProducer<[ImageCategoryModel], APIError> {
        let request = BackgroundCategoriesRequest()
        return apiService.reactive.response(of: request)
    }
}
