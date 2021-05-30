//
//  CommonWebViewRouter.swift

import Foundation
import UIKit

class CommonWebViewRouter: GenericRouter<UINavigationController> {
    func startWith(title: String, link: String) {
        let webViewController = CommonWebViewController(viewModel: .init(router: self,
                                                                          title: title,
                                                                          link: link))
        navigate(to: webViewController)
    }
    
    override func start() {
        startWith(title: "Điều khoản dịch vụ", link: "https://vnexpress.net")
    }
    
    func startTerm(){
        let webViewController = WebViewController()
        navigate(to: webViewController)
    }
}
