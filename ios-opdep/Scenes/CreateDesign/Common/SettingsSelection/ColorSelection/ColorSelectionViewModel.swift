//
//  ColorSelectionViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 8/24/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

struct ColorModel: DesignContent {
    let url: URL? = nil
    let isColor: Bool = true
    let color: UIColor?
    let hexColor: String
    init(hexColor: String) {
        self.color = UIColor.init(hexString: "#" + hexColor)
        self.hexColor = "#" + hexColor
        
    }
}

struct ColorList: Decodable {
    let colors: [String]
}

class ColorSelectionViewModel: GridViewModel {
    var backgroundColor: UIColor { .white }
    var itemSpacing: CGFloat { 20 }
    var padding: CGFloat { 20 }
    var itemsPerUnit: CGFloat { 6 }
    var scrollDirection: UICollectionView.ScrollDirection { .vertical }
    let reloadData: SignalProducer<Void, Never>
    
    let isSelected = MutableProperty<Bool>(false)
    let selectedColor = MutableProperty<ColorModel?>(nil)
    let colors: Property<[ColorModel]>
    
    init() {
        colors = Property(value: AppConstants.colors)
        reloadData = colors.producer.map { _ in }
    }
    
    let cellMapping: [String: UICollectionViewCell.Type] = ["design_grid_cell": DesignGridCell.self]
    
    func numberOfRows(in section: Int) -> Int {
        colors.value.count
    }
    
    func cellIdentifier(at indexPath: IndexPath) -> String {
        "design_grid_cell"
    }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UICollectionViewCell {
        guard let designCell = cell as? DesignGridCell else { fatalError() }
        let model = itemAt(indexPath: indexPath)
        designCell.configure(model: model)
        designCell.withBorder(width: 1,
                              cornerRadius: designCell.frame.width / 2,
                              color: .init(hexString: "#000000", alpha: 0.2))
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        let item = itemAt(indexPath: indexPath)
        selectedColor.swap(item)
    }
    
    func itemAt(indexPath: IndexPath) -> ColorModel {
        colors.value[indexPath.row]
    }
}
