//
//  TemplateWorker.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 6/3/21.
//

import Foundation
import ReactiveSwift

class TemplateWorker {
    
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getAllTemplate() -> SignalProducer<[Template], APIError> {
        let request = TemplateRequest()
        return apiService.reactive.response(of: request).map { $0.template }
    }
    
    func fetchTemplateCategory(categoryId: String) -> SignalProducer<[TemplateCategoryData], APIError> {
        let request = TemplateCategoryRequest(categoryId: categoryId)
        return apiService.reactive.response(of: request).map{
            $0.data
        }
    }
    
    func getPhoneTemplate() -> SignalProducer<[PhoneTemplateData], APIError> {
        let request = PhoneTemplateRequest()
        return apiService.reactive.response(of: request).map { ($0.data ?? []) }
    }
    
    func getPhoneDetailTemplate(categoryId: String) -> SignalProducer<[PhoneListTemplateData], APIError> {
        let request = PhoneListRequest(categoryId: categoryId)
        return apiService.reactive.response(of: request).map { ($0.data ?? []) }
    }
}
