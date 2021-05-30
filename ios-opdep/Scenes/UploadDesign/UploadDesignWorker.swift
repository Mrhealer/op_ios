//
//  UploadDesignWorker.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 12/05/2021.
//

import Foundation
import Alamofire
import ReactiveSwift

class BuyWorker {
    
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func uploadFiles(with userId: String, productId: Int64, photo: Data, preview: Data, printFile: Data) -> SignalProducer<UploadFilesResponse, APIError> {

        let request = UploadDesignsRequest(userId: userId,
                                           productId: productId,
                                           photo: photo,
                                           preview: preview,
                                           print: printFile)
        return apiService.reactive.response(of: request)
    }

}
