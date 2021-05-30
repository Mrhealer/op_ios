//
//  AppRouter.swift

import UIKit

protocol AppRouter {
    var window: UIWindow { get set }
    func resetToHome(tab: HomeTab)
    var topViewController: UIViewController? { get }
    var rootNavigationController: UINavigationController? { get }
    func present(viewController: UIViewController?,
                 animated: Bool,
                 completion: (() -> Void)?)
    func presentAuthenticationPrompt()
}

final class MainRouter {
    var window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
}

extension MainRouter: AppRouter {
    var topViewController: UIViewController? {
        var viewController = window.rootViewController
        while viewController?.presentedViewController != nil {
            viewController = viewController?.presentedViewController
        }
        return viewController
    }
    
    func resetToHome(tab: HomeTab = .home) {
        window.clearContent()
        let navigationController = BasicNavigationController(rootViewController: HomeTabBarViewController(viewModel: .init(startTab: tab)))
        window.rootViewController = navigationController
        UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
    }
    
    func present(viewController: UIViewController?,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        topViewController?.present(viewController, animated: animated, completion: completion)
    }
    
    var rootNavigationController: UINavigationController? {
        guard let navigationController = window.rootViewController as? UINavigationController else {
            return nil
        }
        return navigationController
    }
    
    func resetToAuth() {
        window.clearContent()
//        UserSessionManager.shared.logout()
//        let navigationController = BasicNavigationController()
//        let authRouter = AuthRouter(navigationController)
//        window.rootViewController = navigationController
//        authRouter.startWith(authType: .login)
//        UIView.transition(with: window,
//                          duration: 0.5,
//                          options: .transitionCrossDissolve,
//                          animations: nil,
//                          completion: nil)
    }
    
    func presentAuthenticationPrompt() {
        // Nếu show popup custome thì so sánh kiểu và thay cho UIAlertController
        guard let topViewContoller = topViewController, topViewController as? UIAlertController == nil else { return }
        topViewContoller.presentSimpleAlert(title: "Funpik",
                                            message: "Phiên của bạn đã hết hạn",
                                            callback: { [weak self] in
                                               self?.resetToAuth()
                                            })
    }
}

private extension UIWindow {
    func clearContent() {
        rootViewController?.dismiss(animated: false, completion: nil)
        rootViewController?.view.subviews.forEach { $0.removeFromSuperview() }
        rootViewController?.view.removeFromSuperview()
        subviews.forEach { $0.removeFromSuperview() }
    }
}
