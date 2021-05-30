//
//  GridViewModel.swift

import Foundation
import ReactiveSwift

protocol GridViewModel {
    var padding: CGFloat { get }
    var contentInset: UIEdgeInsets { get }
    var backgroundColor: UIColor { get }
    var itemSpacing: CGFloat { get }
    var lineSpacing: CGFloat { get }
    var interitemSpacing: CGFloat { get }
    // unit là hàng(row - theo verticall) hoặc cột(collumn - theo horizontal). Tức itemsPerUnit là số items được hiển thị trên 1 unit
    var itemsPerUnit: CGFloat { get }
    var scrollDirection: UICollectionView.ScrollDirection { get }
    var isPagingEnabled: Bool { get }
    var cellMapping: [String: UICollectionViewCell.Type] { get }
    func numberOfRows(in section: Int) -> Int
    func cellIdentifier(at indexPath: IndexPath) -> String
    func configure<T: UICollectionViewCell>(cell: T, at indexPath: IndexPath)
    func didSelectItemAt(indexPath: IndexPath)
    func sizeForItem(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize?
    var reloadData: SignalProducer<Void, Never> { get }
    var currentIndexPath: MutableProperty<IndexPath?> { get }
}

extension GridViewModel {
    var padding: CGFloat { 0 }
    
    var contentInset: UIEdgeInsets { UIEdgeInsets(top: itemSpacing,
                                                  left: 0.0,
                                                  bottom: itemSpacing,
                                                  right: 0.0) }
    
    var backgroundColor: UIColor { .white }
        
    var itemSpacing: CGFloat { 5 }
    
    var interitemSpacing: CGFloat { itemSpacing }
    
    var lineSpacing: CGFloat { itemSpacing }
    
    var itemsPerUnit: CGFloat { 1 }
    
    var scrollDirection: UICollectionView.ScrollDirection { .horizontal }
    
    var isPagingEnabled: Bool { false }
    
    func sizeForItem(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize? {
        nil
    }
    
    var currentIndexPath: MutableProperty<IndexPath?> { .init(nil) }
}
