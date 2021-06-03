//
//  TabbarViewModel.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 10/05/2021.
//

import Foundation
import UIKit
import ReactiveSwift

enum HomeTab: Int {
    case infor = 3
    case home = 1
    case cart = 2
    case history = 0
    
    var title: String {
        switch self {
        case .infor: return "Thông tin"
        case .home: return "Trang Chủ"
        case .cart: return "Giỏ Hàng"
        case .history: return "Tính năng"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .infor: return R.image.tabbar_infor()
        case .home: return R.image.tabbar_home()
        case .cart: return R.image.tabbar_cart()
        case .history: return R.image.tabbar_history()
        }
    }
    
    var activedIcon: UIImage? {
        switch self {
        case .infor: return R.image.tabbar_infor_active()
        case .home: return R.image.tabbar_home_active()
        case .cart: return R.image.tabbar_cart_active()
        case .history: return R.image.tabbar_history_active()
        }
    }
}

// define data for a tab
class Module {
    let router: Router
    let container: UINavigationController?
    
    init(container: UINavigationController?,
         router: Router) {
        self.router = router
        self.container = container
    }
}

class TabBarViewModel {
    let customBarViewModel: CustomeTabBarViewModel
    let modules: [Module]
    let startTab: HomeTab
    init(startTab: HomeTab = .home) {
        customBarViewModel = .init()
        self.startTab = startTab
        
        let utilityContainer = BasicNavigationController()
        let Utility = Module(container: utilityContainer,
                             router: UtilityRouter(utilityContainer))
        
        let homeContainer = BasicNavigationController()
        let home = Module(container: homeContainer,
                          router: HomeRouter(homeContainer))
        
        let cartContainer = BasicNavigationController()
        let cart = Module(container: cartContainer,
                          router: ShoppingCartRouter(cartContainer))
        
        let inforContainer = BasicNavigationController()
        let infor = Module(container: inforContainer, router: InformationRouter(inforContainer))
        modules = [Utility, home, cart, infor]
    }
    
    func start() {
        modules[startTab.rawValue].router.start()
    }
    
}
