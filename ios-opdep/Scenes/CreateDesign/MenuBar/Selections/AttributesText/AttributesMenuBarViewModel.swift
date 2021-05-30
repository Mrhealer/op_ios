//
//  AttributesMenuBarViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/3/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

enum Attribute: String, CaseIterable {
    case font
    case fontSize
    case distance
    case interline
    case color
    case shadow
    case align
       
    var image: UIImage? {
        switch self {
        case .font: return R.image.text_font()
        case .fontSize: return R.image.text_font_size()
        case .color: return R.image.text_color()
        case .interline: return R.image.text_interline()
        case .distance: return R.image.text_distance()
        case .shadow: return R.image.text_shadow()
        case .align: return R.image.text_align()
        }
    }
    
    var title: String {
        switch self {
        case .color, .font, .shadow, .interline, .distance, .align: return self.rawValue.uppercased()
        case .fontSize: return "FONT SIZE"
        }
    }
    
    var model: AttributeBarItemViewModel { .init(attribute: self) }
}

class AttributesMenuBarViewModel: GridViewModel {
    var contentInset: UIEdgeInsets { .zero }
    var itemSpacing: CGFloat { 0 }
    let cellMapping: [String: UICollectionViewCell.Type] = ["attribute_bar_item_cell": AttributeBarItemCell.self]
    let backgroundColor: UIColor
    let itemsForDisplay: CGFloat?
    let reloadData: SignalProducer<Void, Never>
    
    let attributes: MutableProperty<[AttributeBarItemViewModel]>
    let selectedAttribute = MutableProperty<AttributeBarItemViewModel?>(nil)
    let currentIndexPath = MutableProperty<IndexPath?>(nil)
    
    init(itemsForDisplay: CGFloat?,
         backgroundColor: UIColor) {
        self.itemsForDisplay = itemsForDisplay
        self.backgroundColor = backgroundColor
        attributes = MutableProperty([Attribute.font, Attribute.fontSize, Attribute.align, Attribute.color].map {
            let viewModel = AttributeBarItemViewModel(attribute: $0)
            viewModel.isSelected.swap(true)
            return AttributeBarItemViewModel(attribute: $0)
        })
        reloadData = attributes.producer.map { _ in }
        selectedAttribute.swap(attributes.value[0])
    }
    
    func numberOfRows(in section: Int) -> Int { attributes.value.count }
    
    func cellIdentifier(at indexPath: IndexPath) -> String { "attribute_bar_item_cell" }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UICollectionViewCell {
        guard let attributeBarItemCell = cell as? AttributeBarItemCell else { fatalError() }
        guard let viewModel = itemAt(indexPath: indexPath) else { return }
        attributeBarItemCell.configure(viewModel: viewModel)
    }
    
    func sizeForItem(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize? {
        var itemWidth = collectionView.bounds.height
        if let itemsForDisplay = itemsForDisplay {
            itemWidth = collectionView.bounds.width / itemsForDisplay
        }
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth,
                      height: itemHeight)
    }
    
    func itemAt(indexPath: IndexPath) -> AttributeBarItemViewModel? {
        guard !attributes.value.isEmpty else { return nil }
        return attributes.value[indexPath.row]
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        selectedAttribute.value?.isSelected.swap(false)
        guard let item = itemAt(indexPath: indexPath) else { return }
        item.isSelected.swap(true)
        selectedAttribute.swap(item)
        currentIndexPath.swap(indexPath)
    }
}
