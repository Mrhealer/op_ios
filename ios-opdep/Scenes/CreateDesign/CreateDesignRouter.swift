//
//  CreateDesignRouter.swift
//  OPOS
//
//  Created by Tran Van Dinh on 6/4/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class CreateDesignRouter: GenericRouter<UINavigationController> {
    
    func startWith(product: ProductModel?,
                   resources: [UIImage?],
                   designType: DesignType = .phone) {
        let createDesignViewController = CreateDesignViewController(viewModel: .init(product: product,
                                                                                     resources: resources,
                                                                                     apiService: APIService.shared,
                                                                                     router: self,
                                                                                     designType: designType))
        navigate(to: createDesignViewController)
    }


    
    func navigateToBuy(product: ProductModel, designModel: OutPutFileModel) {
        let buyRouter = BuyRouter(navigationController)
        buyRouter.start(productModel: product, outPutFile: designModel)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
