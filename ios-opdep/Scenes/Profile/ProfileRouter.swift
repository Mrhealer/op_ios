//
//  ProfileRouter.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 16/05/2021.
//

import Foundation
import UIKit

class ProfileRouter: GenericRouter<UINavigationController> {
    
    func startWith(userId: String) {
        let controller = ListViewController(bridge:  ProfileBridge(viewModel: .init(urserId: userId,
                                                                                    apiService: APIService.shared,
                                                                                    router: self)))
        navigate(to: controller)
    }
    
    override func start() {
        let profileViewController = ListViewController(bridge:  ProfileBridge(viewModel: .init(urserId: "1",
                                                                                               apiService: APIService.shared,
                                                                                               router: self)))
        navigate(to: profileViewController)
    }
    
    func backView() {
        navigationController?.popViewController(animated: true)
    }
}
