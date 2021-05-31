//
//  ShoppingCartRouter.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 11/05/2021.
//

import Foundation
import UIKit

class ShoppingCartRouter: GenericRouter<UINavigationController> {
    
    override func start() {
        let bridge = ListViewController(bridge: ShoppingCartBridge(viewModel: .init(apiService: APIService.shared,
                                                                                    typeScreen: .root,
                                                                                    router: self)))
        navigate(to: bridge)
    }
    
    func startWith() {
        let bridge = ListViewController(bridge: ShoppingCartBridge(viewModel: .init(apiService: APIService.shared,
                                                                                    typeScreen: .navigate,
                                                                                    router: self)))
        navigate(to: bridge)
    }
    
    func navigateToProducts() {
        ProductRouter(AppLogic.shared.appRouter.rootNavigationController).start()
    }
    
    func navigateToDiscount(userId: String) {
        DiscountRouter(AppLogic.shared.appRouter.rootNavigationController).startWith(userId: userId)
    }
    
    func navigationToLogin() {
        InformationRouter(AppLogic.shared.appRouter.rootNavigationController).presentSignIn()
    }
}
