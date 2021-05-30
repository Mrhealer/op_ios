//
//  InformationWorker.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 5/28/21.
//

import Foundation
import ReactiveSwift

class InformationWorker {
    
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
}
