//
//  CustomTabBar.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 10/05/2021.
//

import UIKit

import UIKit
import ReactiveSwift

class TabBarItemViewModel: Equatable {
    let tab: HomeTab
    let isSelected: MutableProperty<Bool>
    let identifier = UUID().uuidString
    init(tab: HomeTab, isSelected: Bool = false) {
        self.tab = tab
        self.isSelected = MutableProperty(isSelected)
    }
    static func == (lhs: TabBarItemViewModel, rhs: TabBarItemViewModel) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func copied() -> TabBarItemViewModel {
        let viewModel = TabBarItemViewModel(tab: self.tab)
        return viewModel
    }
}

class CustomeTabBarViewModel {
    let tabs: MutableProperty<[TabBarItemViewModel]>
    let selectedBarItem: MutableProperty<TabBarItemViewModel?>
    let selectedItem = MutableProperty<TabBarItemViewModel?>((nil))

    init() {
        tabs = .init([TabBarItemViewModel(tab: .history),
                      TabBarItemViewModel(tab: .home),
                      TabBarItemViewModel(tab: .cart),
                      TabBarItemViewModel(tab: .infor)])
        selectedBarItem = .init(tabs.value[1])
        selectedItem <~ selectedBarItem
    }
}

class CustomTabBar: UIView {
    let viewModel: CustomeTabBarViewModel
    var itemViews: [TabBarItemView] = []
    init(viewModel: CustomeTabBarViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        backgroundColor = .white
        whiteShadow()
        let stackView = UIStackView()
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        viewModel.tabs.producer.startWithValues { [weak self, stackView] in
            guard let sself = self else { return }
            let spec = StackSpec(axis: .horizontal,
                                 distribution: UIStackView.Distribution.equalSpacing,
                                 contentInsets: .init(top: 0, left: 24, bottom: 0, right: 24))
            $0.forEach { barItemViewModel in
                let tabBarItemView = TabBarItemView(viewModel: barItemViewModel)
                spec.add(tabBarItemView)
                sself.viewModel.selectedBarItem <~ tabBarItemView.tapRecognizer.reactive.stateChanged
                    .filter { $0.state == .ended }
                    .map { _ in barItemViewModel }
                barItemViewModel.isSelected <~ sself.viewModel.selectedItem.map { [barItemViewModel] in
                    let selectedItem = $0
                    guard let selected = selectedItem else { return false }
                    return selected == barItemViewModel
                }
                sself.itemViews.append(tabBarItemView)
            }
            stackView.reload(with: spec)
        }
    }
    
    func barItemView(with tab: HomeTab) -> TabBarItemView { itemViews[tab.rawValue] }
    
    func center(with tab: HomeTab) -> CGPoint {
        let view = barItemView(with: tab)
        return view.superview?.convert(view.center, to: nil) ?? .zero
    }
}

class TabBarItemView: UIView {
    let viewModel: TabBarItemViewModel
    let tabBarItem = UIView()
    let button = StyleButton(titleFont: .font(style: .bold, size: 12),
                             titleColor: UIColor.BottomBar.textActive,
                             contentInsets: .init(top: 0, left: 24, bottom: 0, right: 24))
    let tapRecognizer = UITapGestureRecognizer()
    
    init(viewModel: TabBarItemViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        addGestureRecognizer(tapRecognizer)
        button.layer.cornerRadius = 20
        button.isUserInteractionEnabled = false
        button.imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: 5)
        
        addSubview(tabBarItem)
        tabBarItem.addSubviews(button)
        
        tabBarItem.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(6)
            $0.bottom.right.equalToSuperview().offset(-6)
        }
        button.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview()
        }
        button.reactive.backgroundColor <~ viewModel.isSelected
            .map { $0 ? UIColor.BottomBar.bgActive : UIColor.Basic.white }
        button.reactive.image <~ viewModel.isSelected.map { [viewModel] in $0 ? viewModel.tab.activedIcon : viewModel.tab.icon }
//        button.reactive.title <~ viewModel.isSelected.map { [viewModel] in $0 ? viewModel.tab.title : "" }
        button.reactive.sizeToFit <~ viewModel.isSelected.map { $0 }
    }
}

extension Reactive where Base: UIButton {
    var sizeToFit: BindingTarget<Any> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            base.sizeToFit()
        }
    }
}
