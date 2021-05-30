//
//  DesignGridViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 8/5/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

// Mục đích: dùng chung cho background,frame,duo,text selection
protocol DesignImageViewModel {
    var designs: MutableProperty<[DesignImageModel]> { get }
    var selectedDesign: MutableProperty<DesignImageModel?> { get }
    func itemAt(indexPath: IndexPath) -> DesignImageModel
}

extension DesignImageViewModel {
    func itemAt(indexPath: IndexPath) -> DesignImageModel {
        designs.value[indexPath.row]
    }

    func didSelectItemAt(indexPath: IndexPath) {
        let item = itemAt(indexPath: indexPath)
        selectedDesign.swap(item)
    }
}

class DesignGridViewModel: GridViewModel, DesignImageViewModel {
    let backgroundColor: UIColor
    let scrollDirection: UICollectionView.ScrollDirection
    let itemsPerUnit: CGFloat
    let padding: CGFloat
    let itemSpacing: CGFloat
    let reloadData: SignalProducer<Void, Never>
    
    let designs = MutableProperty<[DesignImageModel]>([])
    var selectedDesign = MutableProperty<DesignImageModel?>(nil)
    let cellMapping: [String: UICollectionViewCell.Type] = ["design_grid_cell": DesignGridCell.self]
    
    init(backgroundColor: UIColor = .black,
         scrollDirection: UICollectionView.ScrollDirection = .horizontal,
         itemsPerUnit: CGFloat = 1,
         padding: CGFloat = 0,
         itemSpacing: CGFloat = 5) {
        self.backgroundColor = backgroundColor
        self.scrollDirection = scrollDirection
        self.itemsPerUnit = itemsPerUnit
        self.padding = padding
        self.itemSpacing = itemSpacing
        
        reloadData = designs.producer.map { _ in }
    }
    
    func numberOfRows(in section: Int) -> Int { designs.value.count }
    
    func cellIdentifier(at indexPath: IndexPath) -> String { "design_grid_cell" }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UICollectionViewCell {
        guard let designCell = cell as? DesignGridCell else { fatalError() }
        let model = itemAt(indexPath: indexPath)
        designCell.configure(model: model)
    }
}
