//
//  UtilityRouter.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 18/05/2021.
//

import Foundation
import UIKit

class UtilityRouter: GenericRouter<UINavigationController> {
    override func start() {
        let controller = UtilityViewController(viewModel: .init(apiService: APIService.shared,
                                                                router: self))
        navigate(to: controller)
    }
    
    func navigateToProfile(userId: String) {
        ProfileRouter(AppLogic.shared.appRouter.rootNavigationController).startWith(userId: userId)
    }
    
    func navigateToOrderHistory(userId: String) {
        OrderHistoryRouter(AppLogic.shared.appRouter.rootNavigationController).startWith(userId: userId)
    }
    
    func presentSignIn() {
        let navigation = BasicNavigationController()
        let router = LoginRouter(navigation)
        navigation.modalPresentationStyle = .fullScreen
        router.start()
        present(viewController: navigation)
    }
    
    func close() {
        navigationController?.dismiss(animated: true,
                                      completion: nil)
    }
}
