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
        viewController?.bindViewModel(viewModel)
        viewModel.fetchDataCategory()
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
