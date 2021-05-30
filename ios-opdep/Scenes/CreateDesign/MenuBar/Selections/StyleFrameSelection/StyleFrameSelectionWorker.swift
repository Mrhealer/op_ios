//
//  StyleFrameSelectionWorker.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/28/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class StyleFrameSelectionWorker {
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchFrames() -> SignalProducer<[DesignImageModel], APIError> {
        let request = FrameImagesRequest()
        return apiService.reactive.response(of: request)
    }
}
