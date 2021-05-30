//
//  ProfileViewController.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 16/05/2021.
//

import Foundation
import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift
import SkyFloatingLabelTextField

class ProfileBridge: ListViewBridge<ProfileViewModel> {
    
    let buttonSave = StyleButton(title: "Lưu thông tin",
                                 titleFont: .font(style: .medium, size: 16),
                                 titleColor: .white,
                                 backgroundColor: .init(hexString: "B877B1"), rounded: true,
                                 cornerRadius: 13)
    // MARK: Picker view
    private var bottomDesignConstraint: Constraint?
    private var heightPickerView: Int = 250
    
    override func render(tableView: UITableView, in parentView: UIView) {
        viewController?.view.backgroundColor = UIColor.Basic.white
        setupView(tableView: tableView, in: parentView)
    }
    
    private func setupView(tableView: UITableView, in parentView: UIView) {
        let navigationBar = CustomNavigation(title: "Địa chỉ giao hàng",
                                             viewController: viewController)
        navigationBar.nextBarItem.isHidden = true
        let pickerViewContent: CustomPickerView = .init(viewModel: viewModel.customPickerViewModel)
        buttonSave.reactive.pressed = CocoaAction(viewModel.validateInputProfileAction)
        
        parentView.addSubviews(navigationBar,
                               tableView, buttonSave,
                               pickerViewContent.view)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(parentView.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
        buttonSave.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(tableView.snp.bottom).offset(16)
            $0.bottom.equalTo(parentView.safeAreaLayoutGuide).offset(-20)
        }
        pickerViewContent.view.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            bottomDesignConstraint = $0.bottom.equalToSuperview().constraint
            $0.height.equalTo(250)
        }
        viewController?.bindViewModel(viewModel)
        tableView.separatorStyle = .none
        viewModel.fetchProfile()
//        viewController?.hideKeyboardWhenTappedAround()
        bottomDesignConstraint?.update(offset: heightPickerView)
        
        // Save action
        buttonSave.reactive.pressed = CocoaAction(viewModel.validateInputProfileAction)
        viewModel.saveAction.values.observeValues { [weak self] in
            guard let sself = self else { return }
            sself.viewController?.showAlert(title: "Thông báo",
                                            message: $0.message.asStringOrEmpty(),
                                            textOk: "Xác nhận",
                                            okCallBack: { sself.viewModel.nativeToBackView() })
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        62.0
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForFooterInSection section: Int) -> UIView? {
        let container = UIView()
        let textFieldCity = SkyFloatingLabelTextField.create(placeholder: "Tỉnh/ Thành Phố")
        let button = StyleButton()
        textFieldCity.reactive.text <~ viewModel.city
        textFieldCity.isUserInteractionEnabled = false
        container.addSubviews(textFieldCity, button)
        Signal.merge(viewModel.customPickerViewModel.chooseAction.values.map { _ in },
                     viewModel.customPickerViewModel.cancelAction.values)
            .observeValues { [weak self] _ in
                self?.hidePickerCity()
            }
        [textFieldCity, button].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        button.addTarget(self, action: #selector(showPickerCity), for: .touchDown)
        return container
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForFooterInSection section: Int) -> CGFloat {
        46.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
    
    @objc func showPickerCity() {
        updateConstraint(constraint: 0)
    }
    
    func hidePickerCity() {
        updateConstraint(constraint: self.heightPickerView)
    }
    
    func updateConstraint(constraint : Int) {
        self.bottomDesignConstraint?.update(offset: constraint)
        UIView.animate(withDuration: 0.25) {
            self.viewController?.view.layoutIfNeeded()
        }
    }
}
