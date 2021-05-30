//
//  MenuBarView.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/9/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class MenuBarView: UIView {
    let viewModel: MenuBarViewModel
    
    let stackView = UIStackView()
    init(viewModel: MenuBarViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        let space = UIView()
        addSubviews(stackView, space)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        space.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        space.backgroundColor = .init(hexString: "#000000", alpha: 0.5)
        
        viewModel.menus.producer.startWithValues { [viewModel, stackView] in
            let spec = StackSpec(axis: .horizontal,
                                 distribution: .fillEqually)
            $0.forEach { barItemModel in
                let itemContainer = UIView()
                let item = IconButton(axis: .vertical,
                                      title: barItemModel.type.title,
                                      textAlightment: .center,
                                      tintColor: .black)
                itemContainer.addSubview(item)
                spec.add(itemContainer)
                item.snp.makeConstraints {
                    $0.leading.trailing.bottom.equalToSuperview()
                    $0.top.equalToSuperview().offset(12)
                }
                item.setTitleFont(UIFont.important(size: 10))
                item.iconView.reactive.image <~  barItemModel.image
                item.reactive.pressed = CocoaAction(viewModel.selectItemAction) { [barItemModel] _ in barItemModel }
                barItemModel.isSelected <~ viewModel.selectedItem.map { [barItemModel] selected in
                    guard let selected = selected else { return false }
                    return selected == barItemModel
                }
            }
            stackView.reload(with: spec)
        }
    }
}
