//
//  CustomNavigation.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 12/05/2021.
//

import Foundation
import UIKit

class CustomNavigation: UIView {
    let nextBarItem: StyleButton
    let backBarItem: StyleButton
    let labelTitle: StyleLabel
    
    var viewController: UIViewController?
    init(title: String, viewController: UIViewController?) {
        nextBarItem = StyleButton(image: R.image.navigation_next(),
                                  backgroundColor: .clear)
        backBarItem = StyleButton(image: R.image.navigation_back(),
                                  backgroundColor: .clear)
        labelTitle = StyleLabel(text: title,
                                font: UIFont.important(size: 16),
                                textAlignment: .center)
        self.viewController = viewController
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        addSubviews(nextBarItem, labelTitle, backBarItem)
        backBarItem.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.top.leading.bottom.equalToSuperview()
        }
        labelTitle.snp.makeConstraints {
            $0.leading.equalTo(backBarItem.snp.trailing)
            $0.trailing.equalTo(nextBarItem.snp.leading)
            $0.top.bottom.equalToSuperview()
        }
        nextBarItem.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.top.trailing.bottom.equalToSuperview()
        }
        backBarItem.addTarget(self, action: #selector(backScreen), for: .touchUpInside)
    }
    
    @objc func backScreen() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
}
