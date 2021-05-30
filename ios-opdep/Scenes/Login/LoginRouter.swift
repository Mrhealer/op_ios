//
//  LoginRouter.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 27/04/2021.
//

import UIKit

class LoginRouter: GenericRouter<UINavigationController> {
    override func start() {
        let controller = LoginViewController(viewModel: .init(apiService: APIService.shared,
                                                              router: self))
        navigate(to: controller)
    }
    
    func close() {
        navigationController?.dismiss(animated: true,
                                      completion: nil)
    }
}
