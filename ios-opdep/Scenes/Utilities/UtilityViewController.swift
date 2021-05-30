//
//  UtilityViewController.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 18/05/2021.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift
import SkyFloatingLabelTextField

class UtilityViewController: BasicViewController {
    override var shouldHideNavigationBar: Bool { true }
    let viewModel: UtilityViewModel
    
    init(viewModel: UtilityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        bindViewModel(viewModel)
        view.backgroundColor = UIColor.Basic.white
        prepare()
    }
    
    func prepare() {
        let safeAreaView = StyleView(backgroundColor: .init(hexString: "8D7AA5"))
        let headerView = buildHeader()
        let buttonShippingInfo = StyleButton(title: "Thông tin giao hàng")
        settingButton(button: buttonShippingInfo)
        let stackViewCart = buildStackViewCart()
        let stackViewFaceBook = buildStackViewFaceBook()
        let buttonPolicy = StyleButton(title: "Chính sách")
        settingButton(button: buttonPolicy)
    
        view.addSubviews(safeAreaView, headerView,
                         buttonShippingInfo, stackViewCart,
                         stackViewCart, stackViewFaceBook, buttonPolicy)
        
        safeAreaView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(headerView.snp.top)
        }
        headerView.snp.makeConstraints {
            $0.height.equalTo(120)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        buttonShippingInfo.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(headerView.snp.bottom).offset(-16)
        }
        stackViewCart.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(buttonShippingInfo.snp.bottom).offset(16)
        }
        stackViewFaceBook.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(stackViewCart.snp.bottom).offset(16)
        }
        buttonPolicy.snp.makeConstraints {
            let width = (UIScreen.main.bounds.size.width - 24 - 24 - 24) / 2
            $0.size.equalTo(CGSize(width: width, height: 55))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stackViewFaceBook.snp.bottom).offset(16)
        }
        buttonShippingInfo.reactive.pressed = CocoaAction(viewModel.navigateToProfileAction)
    }
    
    func buildHeader() -> UIView {
        let container = StyleView(backgroundColor: .init(hexString: "8D7AA5"))
        container.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        container.clipsToBounds = true
        container.layer.cornerRadius = 24

        let logoView = UIImageView(image: R.image.logo())
        logoView.contentMode = .scaleAspectFit
        container.addSubviews(logoView)
        logoView.snp.makeConstraints {
            $0.height.equalTo(70)
            $0.center.equalToSuperview()
        }
        return container
    }
    
    func buildStackViewCart() -> UIStackView {
        let stackView = UIStackView()
        let buttonCart = StyleButton(title: "Lịch sử đơn hàng")
        settingButton(button: buttonCart)
        let buttonInstagram = StyleButton(title: "Instagram")
        settingButton(button: buttonInstagram)
        let spec = StackSpec(axis: .horizontal,
                             items: [buttonCart, buttonInstagram],
                             distribution: .fillEqually,
                             spacing: 24,
                             contentInsets: .init(top: 0, left: 24, bottom: 0, right: 24))
        stackView.reload(with: spec)
        buttonCart.reactive.pressed = CocoaAction(viewModel.navigateToOrderHistoryAction)
        return stackView
    }
    
    func buildStackViewFaceBook() -> UIStackView {
        let stackView = UIStackView()
        let buttonFacebook = StyleButton(title: "Facebook")
        settingButton(button: buttonFacebook)
        let buttonShare = StyleButton(title: "Chia sẻ")
        settingButton(button: buttonShare)
        let spec = StackSpec(axis: .horizontal,
                             items: [buttonFacebook, buttonShare],
                             distribution: .fillEqually,
                             spacing: 24,
                             contentInsets: .init(top: 0, left: 24, bottom: 0, right: 24))
        stackView.reload(with: spec)
        return stackView
    }
    
    func settingButton(button: StyleButton) {
        button.rounded = true
        button.cornerRadius = 16
        button.titleLabel?.font = .font(style: .bold, size: 12)
        button.setTitleColor(UIColor.Basic.white, for: .normal)
        button.backgroundColor = .init(hexString: "A29E9E")

    }
}
