//
//  ImageFilterSelectionViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 8/1/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class ImageFilterModel {
    let isSelected = MutableProperty<Bool>(false)
    let index: Int
    let filterName: String
    let imageName: String
    init(index: Int, filterName: String, imageName: String) {
        self.index = index
        self.filterName = filterName
        self.imageName = imageName
    }
}

class ImageFilterSelectionViewModel: GridViewModel {
    let isSelected = MutableProperty<Bool>(false)
    var backgroundColor: UIColor { .white }
    var itemSpacing: CGFloat { 20 }
    var contentInset: UIEdgeInsets { .zero }
    let reloadData: SignalProducer<Void, Never>
    
    let filters: Property<[ImageFilterModel]>
    let selectedFilter = MutableProperty<ImageFilterModel?>(nil)
    
    init() {
        filters = Property(value: [ImageFilterModel(index: 0, filterName: "No Filter", imageName: "filter_n0"),
                   ImageFilterModel(index: 1, filterName: "whiteskin", imageName: "filter_n1"),
                   ImageFilterModel(index: 2, filterName: "crisp", imageName: "filter_n2"),
                   ImageFilterModel(index: 3, filterName: "deep", imageName: "filter_n3"),
                   ImageFilterModel(index: 4, filterName: "fresh", imageName: "filter_n4"),
                   ImageFilterModel(index: 5, filterName: "green", imageName: "filter_n5"),
                   ImageFilterModel(index: 6, filterName: "juicy", imageName: "filter_n6"),
                   ImageFilterModel(index: 7, filterName: "mint", imageName: "filter_n7"),
                   ImageFilterModel(index: 8, filterName: "morning", imageName: "filter_n8"),
                   ImageFilterModel(index: 9, filterName: "purple", imageName: "filter_n9"),
                   ImageFilterModel(index: 10, filterName: "red", imageName: "filter_n10"),
                   ImageFilterModel(index: 11, filterName: "serene", imageName: "filter_n11"),
                   ImageFilterModel(index: 12, filterName: "sweet", imageName: "filter_n12"),
                   ImageFilterModel(index: 13, filterName: "whiteskin", imageName: "filter_n13")])
        reloadData = filters.producer.map { _ in }
    }
    
    func itemAt(indexPath: IndexPath) -> ImageFilterModel {
        filters.value[indexPath.row]
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        selectedFilter.value?.isSelected.swap(false)
        let item = itemAt(indexPath: indexPath)
        item.isSelected.swap(true)
        selectedFilter.swap(item)
    }
    
    func resetSelectedFilter() {
        selectedFilter.value?.isSelected.swap(false)
    }
    
    var cellMapping: [String: UICollectionViewCell.Type] = ["image_filter_selection_cell": ImageFilterSelectionCell.self]
    
    func numberOfRows(in section: Int) -> Int { filters.value.count }
    
    func cellIdentifier(at indexPath: IndexPath) -> String { "image_filter_selection_cell" }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UICollectionViewCell {
        guard let filterCell = cell as? ImageFilterSelectionCell else { fatalError() }
        let model = itemAt(indexPath: indexPath)
        filterCell.configure(model: model)
    }
    
    func sizeForItem(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize? {
        CGSize(width: collectionView.bounds.height - itemSpacing,
               height: collectionView.bounds.height - itemSpacing)
    }
}
