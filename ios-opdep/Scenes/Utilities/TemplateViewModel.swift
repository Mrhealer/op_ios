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
}
