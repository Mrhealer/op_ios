//
//  UploadDesignRouter.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 12/05/2021.
//

import Foundation
import ReactiveSwift
import UIKit

class BuyRouter: GenericRouter<UINavigationController> {
    
    func start(productModel: ProductModel, outPutFile: OutPutFileModel) {
        let buyViewController = BuyViewController(viewModel: .init(productModel: productModel,
                                                                   outputFile: outPutFile,
                                                                   apiService: APIService.shared,
                                                                   router: self))
        navigate(to: buyViewController)
    }
    
    func presentSignIn() {
        let navigation = BasicNavigationController()
        let router = LoginRouter(navigation)
        navigation.modalPresentationStyle = .fullScreen
        router.start()
        present(viewController: navigation)
    }
    
    func navigateToCart(_ userId: String) {
        ShoppingCartRouter(navigationController).startWith()
    }
}
