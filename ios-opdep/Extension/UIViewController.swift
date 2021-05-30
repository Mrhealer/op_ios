//
//  UIViewController.swift

import UIKit
import MBProgressHUD

private let kHUDTag = 1234
public extension UIViewController {
    func presentSimpleAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true,
                completion: nil)
    }
    
    func presentSimpleAlert(title: String?, message: String, callback: @escaping () -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in callback()}))
        present(alert, animated: true,
                completion: nil)
    }
    
    func presentConfirmationAlert(title: String? = nil, message: String,
                                  okOption: String, cancelOption: String,
                                  okCallback: @escaping () -> Void, cancelCallback: @escaping () -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okOption,
                                      style: .default,
                                      handler: { _ in okCallback()}))
        alert.addAction(UIAlertAction(title: cancelOption,
                                      style: .cancel,
                                      handler: { _ in cancelCallback()}))
        present(alert, animated: true,
                completion: nil)
    }
    
    func showAlert(title: String,
                   message: String,
                   textOk: String,
                   okCallBack: @escaping() -> Void) {
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: textOk,
                                     style: .default,
                                     handler: { _ in okCallBack()})
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    var progressIndicator: MBProgressHUD? {
        let huds = view.subviews.reversed().compactMap { $0 as? MBProgressHUD }
        return huds.first { $0.tag == kHUDTag }
    }
    
    func showProgressIndicator() {
        DispatchQueue.main.async {
            guard self.progressIndicator == nil else {
                self.progressIndicator?.show(animated: true)
                return
            }
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.tag = kHUDTag
        }
    }
    
    func hideProgressIndicator() {
        DispatchQueue.main.async {
            self.progressIndicator?.hide(animated: true)
        }
    }
}
