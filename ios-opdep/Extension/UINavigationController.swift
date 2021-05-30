//
//  UINavigationController.swift

import UIKit

extension UINavigationController {
    func applyPrimaryStyle() {
        navigationBar.setBackgroundImage(nil,
                                         for: .default)
        navigationBar.shadowImage = UIImage.imageWithColor(UIColor.Basic.white)
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = UIColor.Basic.primary
        navigationBar.tintColor = .white
        navigationBar.barTintColor = UIColor.Basic.primary
//        navigationBar.backIndicatorImage = R.image.ic_back_black()
//        navigationBar.backIndicatorTransitionMaskImage = R.image.ic_back_black()
    }
    
    func applySecondaryStyle() {
        navigationBar.setBackgroundImage(nil,
                                         for: .default)
        navigationBar.shadowImage = UIImage.imageWithColor(UIColor.Basic.secondary)
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = UIColor.Basic.white
        navigationBar.tintColor = UIColor.Basic.secondary
        navigationBar.barTintColor = UIColor.Basic.white
//        navigationBar.backIndicatorImage = R.image.ic_back_black()
//        navigationBar.backIndicatorTransitionMaskImage = R.image.ic_back_black()
    }
    
    func applyTransparentStyle() {
        navigationBar.setBackgroundImage(UIImage(),
                                         for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
        navigationBar.tintColor = .white
//        navigationBar.backIndicatorImage = R.image.ic_back_black()
//        navigationBar.backIndicatorTransitionMaskImage = R.image.ic_back_black()
    }

    func replaceCurrentViewController(with viewController: UIViewController, animated: Bool = true) {
        var viewControllerStack = viewControllers
        defer {
            viewControllerStack.append(viewController)
            setViewControllers(viewControllerStack, animated: animated)
        }
        
        guard !viewControllers.isEmpty else { return }
        
        _ = viewControllerStack.popLast()
    }
}
