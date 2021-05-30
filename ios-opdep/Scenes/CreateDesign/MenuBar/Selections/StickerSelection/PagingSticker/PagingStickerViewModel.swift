//
//  PagingStickerViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/21/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class PagingStickerViewModel: GridViewModel {
    var itemSpacing: CGFloat { 0 }
    var contentInset: UIEdgeInsets { .zero }
    var backgroundColor: UIColor { .white }
    var isPagingEnabled: Bool { true }
    let cellMapping: [String: UICollectionViewCell.Type] = ["paging_sticker_cell" : PagingStickerCell.self]
    let reloadData: SignalProducer<Void, Never>
    
    let categories = MutableProperty<[CategoryBarItemViewModel]>([])
    let currentIndexPath = MutableProperty<IndexPath?>(nil)
    var scrollToItem: Signal<IndexPath?, Never> = .empty
    let selectedSticker = MutableProperty<URL?>(nil)
    
    init() {
        reloadData = categories.producer.map { _ in }
    }
    
    func itemAt(indexPath: IndexPath) -> CategoryBarItemViewModel {
        categories.value[indexPath.row]
    }
    
    func numberOfRows(in section: Int) -> Int { categories.value.count }
    
    func cellIdentifier(at indexPath: IndexPath) -> String { "paging_sticker_cell" }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UICollectionViewCell {
        guard let pagingStickerCell = cell as? PagingStickerCell else { fatalError() }
        let viewModel = itemAt(indexPath: indexPath)
        pagingStickerCell.configure(viewModel: viewModel)
        selectedSticker <~ pagingStickerCell.designGridView.viewModel.selectedDesign.signal.take(until: pagingStickerCell.reactive.prepareForReuse).map { $0?.imageUrl }
    }
    
    func sizeForItem(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize? {
        collectionView.bounds.size
    }
    
    func didSelectItemAt(indexPath: IndexPath) { }
}
