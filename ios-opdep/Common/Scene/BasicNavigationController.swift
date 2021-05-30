//
//  BasicNavigationController.swift

import UIKit

class BasicNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    var rootRouter: Router?
    override func viewDidLoad() {
        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.font(style: .bold,
                               size: 14)
        ]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        .fade
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        topViewController?.prefersHomeIndicatorAutoHidden ?? false
    }
    
    override var prefersStatusBarHidden: Bool { true }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        guard let topViewController = viewControllers.last else { return }
        applyNavigationStyle(of: topViewController, animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        applyNavigationStyle(of: viewController, animated: animated)
        topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                                              style: .plain,
                                                                              target: nil,
                                                                              action: nil)
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let remainingViewControlls = viewControllers.dropLast()
        if let previousViewController = remainingViewControlls.last {
            applyNavigationStyle(of: previousViewController, animated: animated)
        }
        return super.popViewController(animated: animated)
    }
    
    private func applyNavigationStyle(of viewController: UIViewController, animated: Bool) {
        setNavigationBarHidden(viewController.shouldHideNavigationBar,
                               animated: animated)
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.font(style: .bold,
                               size: 14)
        ]
        switch viewController.navigationStyle {
        case .transparent:
            applyTransparentStyle()
        case .secondary:
            navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.Basic.secondary,
                .font: UIFont.font(style: .bold,
                                   size: 14)
            ]
            applySecondaryStyle()
        default:
            applyPrimaryStyle()
        }
        
        viewController.hidesBottomBarWhenPushed = viewController.shouldHideBottomBar
    }
    
    override var childForStatusBarStyle: UIViewController? { topViewController }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else { return true }
        return viewControllers.count > 1
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        navigationController.view.setNeedsLayout()
        navigationController.view.layoutIfNeeded()
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        viewController.hidesBottomBarWhenPushed = false
    }
}

@objc enum NavigationStyle: Int {
    /// Fully transparent background
    case transparent
    /// Transparent background with gradient background
    case blackOpaque
    /// Solid white background
    case primary
    
    case secondary
    /// Fully transparent background with dark content
    case transparentDarkContent
}

protocol NavigationStyleApplicable: UIViewController {
    /// Provide navigation style
    var navigationStyle: NavigationStyle { get }
    /// Control whether hide navigation bar
    var shouldHideNavigationBar: Bool { get }
    /// Control whether hide bottom bar (like tab bar) after pushed
    var shouldHideBottomBar: Bool { get }
}

@objc extension UIViewController: NavigationStyleApplicable {
    var navigationStyle: NavigationStyle { .primary }
    var shouldHideNavigationBar: Bool { true }
    var shouldHideBottomBar: Bool { false }
}
