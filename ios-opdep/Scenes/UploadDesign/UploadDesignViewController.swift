//
//  UploadDesignViewController.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 12/05/2021.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class BuyViewController: BasicViewController {
    
    let imagePreview = StyleImageView()
    let buttonNext: StyleButton
    
    let viewModel: BuyViewModel
    init(viewModel: BuyViewModel) {
        self.viewModel = viewModel
        buttonNext = .init(title: Localize.UploadDesign.next,
                           titleFont: .font(style: .bold, size: 16),
                           titleColor: .white,
                           backgroundColor: .init(hexString: "B877B1"), rounded: true,
                           cornerRadius: 13)
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        prepare()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViews()
        bindViewModel(viewModel)
        view.backgroundColor = UIColor.Basic.white
    }
    
    private func prepare() {
        let navigationBar = CustomNavigation(title: Localize.UploadDesign.title,
                                             viewController: self)
        
        view.addSubviews(navigationBar, imagePreview, buttonNext)
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(60)
        }
        imagePreview.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        buttonNext.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.top.equalTo(imagePreview.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        buttonNext.reactive.pressed = CocoaAction(viewModel.checkLoginAction)
        navigationBar.nextBarItem.reactive.pressed = CocoaAction(viewModel.checkLoginAction)
    }
    
    private func bindingViews() {
        guard let preview = viewModel.outPutFile.value.preview else { return }
        imagePreview.image = UIImage(data: preview)
    }
}
