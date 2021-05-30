//
//  AttributeFontWorker.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/5/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class AttributeFontWorker {
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchFontImages() -> SignalProducer<[DesignImageModel], APIError> {
        let request = FontImagesRequest()
        return apiService.reactive.response(of: request)
    }
}
