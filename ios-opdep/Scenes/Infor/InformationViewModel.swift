//
//  InformationViewModel.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 5/28/21.
//

import Foundation

import ReactiveSwift
import FirebaseAuth

class InformationViewModel : BasicViewModel {
    typealias OutputError = Error
    let errors: Signal<Error, Never>
    let isLoading: Signal<Bool, Never>

    let navigateToProfileAction: Action<Void, Void, Never>
    let navigateToOrderHistoryAction: Action<Void, Void, Never>
    
    let router: InformationRouter
    let worker: InformationWorker
    
    init(apiService: APIService,
         router: InformationRouter) {
        self.router = router
        self.worker = .init(apiService: apiService)
        
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
}

