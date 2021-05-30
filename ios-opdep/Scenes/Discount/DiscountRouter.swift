//
//  DiscountRouter.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 14/05/2021.
//

import UIKit

class DiscountRouter: GenericRouter<UINavigationController> {
    func startWith(userId: String) {
        let controller = DiscountViewController(viewModel: .init(userId: userId,
                                                                 apiService: APIService.shared,
                                                                 router: self))
        navigate(to: controller)
    }
    
    func backToHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func navigateToProfile(userId: String) {
        ProfileRouter(navigationController).startWith(userId: userId)
    }
}
