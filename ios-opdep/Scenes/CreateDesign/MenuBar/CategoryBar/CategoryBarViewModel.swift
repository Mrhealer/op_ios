//
//  CategoryBarViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class CategoryBarViewModel: GridViewModel {
    var contentInset: UIEdgeInsets { .zero }
    var itemSpacing: CGFloat { 0 }
    let cellMapping: [String: UICollectionViewCell.Type] = ["category_bar_item_cell": CategoryBarItemCell.self]
    let backgroundColor: UIColor
    let itemsForDisplay: CGFloat?
    let reloadData: SignalProducer<Void, Never>
    
    let categories: MutableProperty<[CategoryBarItemViewModel]>
    let selectedCategory = MutableProperty<CategoryBarItemViewModel?>(nil)
    let currentIndexPath = MutableProperty<IndexPath?>(nil)
    
    init(itemsForDisplay: CGFloat?,
         backgroundColor: UIColor, categories: [CategoryBarItemViewModel] = []) {
        self.itemsForDisplay = itemsForDisplay
        self.backgroundColor = backgroundColor
        self.categories = MutableProperty(categories)
        reloadData = self.categories.producer.map { _ in }
        
        self.categories.producer.startWithCompleted { [weak self] in
            self?.didSelectItemAt(indexPath: IndexPath(row: 0,
                                                       section: 0))
        }
    }
    
    func numberOfRows(in section: Int) -> Int { categories.value.count }
    
    func cellIdentifier(at indexPath: IndexPath) -> String { "category_bar_item_cell" }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UICollectionViewCell {
        guard let categoryBarItemCell = cell as? CategoryBarItemCell else { fatalError() }
        guard let viewModel = itemAt(indexPath: indexPath) else { return }
        categoryBarItemCell.configure(viewModel: viewModel)
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
    
    func itemAt(indexPath: IndexPath) -> CategoryBarItemViewModel? {
        guard !categories.value.isEmpty else { return nil }
        return categories.value[indexPath.row]
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        selectedCategory.value?.isSelected.swap(false)
        guard let item = itemAt(indexPath: indexPath) else { return }
        item.isSelected.swap(true)
        selectedCategory.swap(item)
        currentIndexPath.swap(indexPath)
    }
}
