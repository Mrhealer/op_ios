//
//  HomeRouter.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 24/04/2021.
//

import Foundation
import UIKit

class HomeRouter: GenericRouter<UINavigationController> {
    
    override func start() {
        let bridge = ListViewController(bridge: HomeBridge(viewModel: .init(apiService: APIService.shared,
                                                                            router: self)))
        navigate(to: bridge)
    }
    
    func navigateToProducts(category: Categories) {
        ProductRouter(AppLogic.shared.appRouter.rootNavigationController).startWith(category: category)
    }
}
