//
//  ProductGridViewModel.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 03/05/2021.
//

import Foundation
import ReactiveSwift

class ProductGridViewModel: GridViewModel {
    var contentInset: UIEdgeInsets { .zero }
    var itemSpacing: CGFloat { 0 }
    let cellMapping: [String: UICollectionViewCell.Type] = ["product_gird_cell": ProductGirdCell.self]
    let reloadData: SignalProducer<Void, Never>
    var scrollDirection: UICollectionView.ScrollDirection { .vertical }
    let backgroundColor: UIColor
    let itemsForDisplay: CGFloat?
    
    let selectedToItem: Action<ProductModel?, ProductModel?, Never>
    
    let products = MutableProperty<[ProductModel]>([])
    
    init(itemsForDisplay: CGFloat?,
         backgroundColor: UIColor) {
        self.itemsForDisplay = itemsForDisplay
        self.backgroundColor = backgroundColor
        
        selectedToItem = Action { input in .init(value: input) }
        
        reloadData = products.producer.map { _ in }
    }
    
    func numberOfRows(in section: Int) -> Int { products.value.count }
    
    func cellIdentifier(at indexPath: IndexPath) -> String { "product_gird_cell" }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UICollectionViewCell {
        guard let cell = cell as? ProductGirdCell else { fatalError() }
        guard let viewModel = itemAt(indexPath: indexPath) else { return }
        cell.configure(viewModel: viewModel)
    }
    
    func sizeForItem(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize? {
        var itemWidth = collectionView.bounds.width
        if let itemsForDisplay = itemsForDisplay {
            itemWidth = (collectionView.bounds.width) / itemsForDisplay
        }
        return CGSize(width: itemWidth,
                      height: itemWidth * 136 / 128)
    }
    
    func itemAt(indexPath: IndexPath) -> ProductModel? {
        guard !products.value.isEmpty else { return nil }
        return products.value[indexPath.row]
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        let model = itemAt(indexPath: indexPath)
        selectedToItem.apply(model).start()
    }
}
