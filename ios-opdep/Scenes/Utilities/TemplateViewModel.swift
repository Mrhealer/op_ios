//
//  TemplateViewModel.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 6/3/21.
//

import Foundation
import ReactiveSwift
import FirebaseAuth

class TemplateViewModel: BasicViewModel {
    typealias OutputError = Error
    let errors: Signal<Error, Never>
    let isLoading: Signal<Bool, Never>

    let navigateToProfileAction: Action<Void, Void, Never>
    let navigateToOrderHistoryAction: Action<Void, Void, Never>
    
    let fetchTemplateAction: Action<Void, [Template], APIError>
    let templateData = MutableProperty<[Template]>([])
    
    
    let fetchTemplateCategoryAction: Action<Void, [TemplateCategoryData], APIError>
    let templateCategoryData = MutableProperty<[TemplateCategoryData]>([])
    let categoryId = MutableProperty<String?>(nil)
    let fetchPhoneTemplateAction: Action<Void, [PhoneTemplateData], APIError>
    let phoneTemplateData = MutableProperty<[PhoneTemplateData]>([])
    let fetchPhoneListAction: Action<Void, [PhoneListTemplateData], APIError>
    let phoneListData = MutableProperty<[PhoneListTemplateData]>([])
    
    let router: TemplateRouter
    let worker: TemplateWorker
    
    init(apiService: APIService,
         router: TemplateRouter) {
        self.router = router
        self.worker = .init(apiService: apiService)
        
        fetchTemplateAction = Action { [worker] in
            worker.getAllTemplate()
        }
        
        templateData <~ fetchTemplateAction.values
        
        fetchTemplateCategoryAction = Action(state: categoryId) {[worker] categoryId in
            worker.fetchTemplateCategory(categoryId: categoryId.asStringOrEmpty())
        }
        
        templateCategoryData <~ fetchTemplateCategoryAction.values
        
        fetchPhoneTemplateAction = Action() {[worker] in
            worker.getPhoneTemplate()
        }
        
        phoneTemplateData <~ fetchPhoneTemplateAction.values
        
        fetchPhoneListAction = Action(state: categoryId) {[worker] categoryId in
            worker.getPhoneDetailTemplate(categoryId: categoryId.asStringOrEmpty())
        }
        
        phoneListData <~ fetchPhoneListAction.values

        navigateToProfileAction = Action { [router] in
            if let userId = apiService.keyStore.userId {
                router.navigateToProfile(userId: userId)
            } else {
                router.presentSignIn()
            }
            return .init(value: ())
        }

        navigateToOrderHistoryAction = Action { [router] in
            let userId = apiService.keyStore.userId.asStringOrEmpty()
            router.navigateToOrderHistory(userId: userId)
            return .init(value: ())
        }

        errors = .empty
        isLoading = .empty
    }
    
    func fetchTemplate() {
        fetchTemplateAction.apply().start()
    }
    
    func fetchTemplateCategory(categoryId: String) {
        self.categoryId.value = categoryId
        fetchTemplateCategoryAction.apply().start()
    }
    
    func fetchPhoneTemplate() {
        fetchPhoneTemplateAction.apply().start()
    }
    
    func fetchPhoneList(categoryId: String) {
        self.categoryId.value = categoryId
        fetchPhoneListAction.apply().start()
    }
}
