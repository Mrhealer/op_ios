//
//  HomeViewController.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 24/04/2021.
//

import UIKit
import GoogleMobileAds

class HomeBridge: ListViewBridge<HomeViewModel> {
    
    override func render(tableView: UITableView, in parentView: UIView) {
        setupView(tableView: tableView, in: parentView)
    }
    
    private func setupView(tableView: UITableView, in parentView: UIView) {
        tableView.separatorStyle = .none
        viewController?.view.backgroundColor = .white
        parentView.addSubviews(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(parentView.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(parentView.safeAreaLayoutGuide).offset(-AppConstants.Common.tabBarHeight)
        }
        viewModel.viewController = self.viewController
        viewController?.bindViewModel(viewModel)
        viewModel.fetchDataCategory()
        viewModel.fetchDataCategoryAction.values.observeValues { _ in
            var array = self.viewModel.categories.value
            for (index, item) in array.enumerated(){
                if (index % 3 == 0 && index != 0) {
                    var category = Categories.init(id: 1, name: "", imageUrl: "")
                    category.type = 0
                    array.insert(category,at: index)
                }
            }
            self.viewModel.categories.value = array
        }
        
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        AppConstants.Common.heightItemHome
    }
}
