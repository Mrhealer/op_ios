//
//  ImageEffectsMenuBarViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/9/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

enum ImageEffect: String, CaseIterable {
    case filter
    case saturation
    case brightness
    case contrast
  
    var image: UIImage? {
        switch self {
        case .filter: return R.image.setting_filter()
        case .saturation: return R.image.setting_saturation()
        case .brightness: return R.image.setting_brightness()
        case .contrast: return R.image.setting_contrast()
        }
    }
    
    var title: String {
        switch self {
        case .filter: return "Bộ lọc"
        case .saturation: return "Phối màu"
        case .brightness: return "Độ sáng"
        case .contrast: return "Tương phản"
        }
    }
    
    var model: ImageEffectItemViewModel { .init(effect: self) }
}

class ImageEffectItemViewModel {
    let effect: ImageEffect
    let isSelected = MutableProperty<Bool>(false)
    
    init(effect: ImageEffect) {
        self.effect = effect
    }
}

class ImageEffectsMenuBarViewModel: GridViewModel {
    var contentInset: UIEdgeInsets { .zero }
    var itemSpacing: CGFloat { 0 }
    let cellMapping: [String: UICollectionViewCell.Type] = ["image_effect_bar_item_cell": ImageEffectBarItemCell.self]
    let reloadData: SignalProducer<Void, Never>
    
    let backgroundColor: UIColor
    let itemsForDisplay: CGFloat?
    let effects: MutableProperty<[ImageEffectItemViewModel]>
    let selectedEffect = MutableProperty<ImageEffectItemViewModel?>(nil)
    let currentIndexPath = MutableProperty<IndexPath?>(nil)
    
    init(itemsForDisplay: CGFloat?,
         backgroundColor: UIColor) {
        self.itemsForDisplay = itemsForDisplay
        self.backgroundColor = backgroundColor
        effects = MutableProperty(ImageEffect.allCases.enumerated().map {
            if $0.offset == 0 {
                let viewModel = ImageEffectItemViewModel(effect: $0.element)
                viewModel.isSelected.swap(true)
                return viewModel
            }
            return ImageEffectItemViewModel(effect: $0.element)
        })
        reloadData = effects.producer.map { _ in }
        selectedEffect.swap(effects.value[0])
    }
    
    func numberOfRows(in section: Int) -> Int { effects.value.count }
    
    func cellIdentifier(at indexPath: IndexPath) -> String { "image_effect_bar_item_cell" }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UICollectionViewCell {
        guard let effectBarItemCell = cell as? ImageEffectBarItemCell else { fatalError() }
        guard let viewModel = itemAt(indexPath: indexPath) else { return }
        effectBarItemCell.configure(viewModel: viewModel)
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
    
    func itemAt(indexPath: IndexPath) -> ImageEffectItemViewModel? {
        guard !effects.value.isEmpty else { return nil }
        return effects.value[indexPath.row]
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        selectedEffect.value?.isSelected.swap(false)
        guard let item = itemAt(indexPath: indexPath) else { return }
        item.isSelected.swap(true)
        selectedEffect.swap(item)
        currentIndexPath.swap(indexPath)
    }
}
