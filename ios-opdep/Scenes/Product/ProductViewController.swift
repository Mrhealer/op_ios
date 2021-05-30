//
//  ProductViewController.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 03/05/2021.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ProductViewController: BasicViewController {

    let productGridView: GridView<ProductGridViewModel>
    private let viewModel: ProductViewModel
    
    init(viewModel: ProductViewModel) {
        self.viewModel = viewModel
        productGridView = .init(viewModel: viewModel.productGridViewModel)
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        bindViewModel(viewModel)
        viewModel.fetchDataProduct()
        view.backgroundColor = .white
        prepare()
    }
    
    func prepare() {
        let navigationBar = CustomNavigation(title: viewModel.categoryName.value,
                                             viewController: self)
        view.addSubviews(navigationBar, productGridView)
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        productGridView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(10)
            $0.left.bottom.right.equalToSuperview()
        }
        binding()
    }
    
    func binding() {
    }
}
