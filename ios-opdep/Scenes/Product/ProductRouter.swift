//
//  ProductRouter.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 03/05/2021.
//

import Foundation
import UIKit

class ProductRouter: GenericRouter<UINavigationController> {
    
    func startWith(category: Categories) {
        let controller = ProductViewController(viewModel: .init(category: category,
                                                                router: self,
                                                                apiService: APIService.shared))
        navigate(to: controller)
    }
    
    func navigateToCreateDesign(product: ProductModel,
                                resources: [UIImage?]) {
        CreateDesignRouter(navigationController).startWith(product: product,
                                                           resources: resources)
    }
}
