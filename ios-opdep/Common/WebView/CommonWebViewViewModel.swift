//
//  CommonWebViewViewModel.swift

import Foundation

class CommonWebViewViewModel {
    let title: String
    let link: String
    let router: CommonWebViewRouter
    init(router: CommonWebViewRouter,
         title: String,
         link: String) {
        self.router = router
        self.title = title
        self.link = link
    }
}
