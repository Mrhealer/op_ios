//
//  TabbarViewController.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 10/05/2021.
//

import Foundation
import UIKit
import ReactiveSwift

final class HomeTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    let viewModel: TabBarViewModel
    let customTabBar: CustomTabBar
    let bottomSafeView = UIView()
    let tabBarHeight: CGFloat = 60.0
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        customTabBar = .init(viewModel: viewModel.customBarViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        bottomSafeView.backgroundColor = .white
        view.addSubviews(customTabBar, bottomSafeView)
        
        customTabBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(tabBarHeight)
        }
        bottomSafeView.snp.makeConstraints {
            $0.top.equalTo(customTabBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        delegate = self
        prepareModules()
        viewModel.start()
        selectedIndex = viewModel.startTab.rawValue
        // binding
        viewModel.customBarViewModel.selectedItem.signal.observeValues { [weak self] in
            guard let sself = self else { return }
            let selectedItem = $0
            guard let selected = selectedItem else { return }
            let userID = Property(value: APIService.shared.keyStore.userId.asStringOrEmpty())
            if userID.value.isEmpty && selected.tab.rawValue == HomeTab.cart.rawValue {
                InformationRouter(AppLogic.shared.appRouter.rootNavigationController).presentSignIn()
            }
            let module = sself.viewModel.modules[selected.tab.rawValue]
            if module.container?.viewControllers.isEmpty == true {
                module.router.start()
            }
            sself.selectedIndex = selected.tab.rawValue
        }
    }
    
    func showAlertForcePretest() {

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.invalidateIntrinsicContentSize()
    }
}

// MARK: - Others
extension HomeTabBarViewController {
    func prepareModules() {
        let viewControllers: [UINavigationController] = viewModel.modules.compactMap {
            let navigationController = $0.container
            return navigationController
        }
        setViewControllers(viewControllers, animated: false)
    }
    
    func topViewController(controller: UIViewController?) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return navigationController.topViewController
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        return controller
    }
}
