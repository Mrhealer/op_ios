//
//  StyleFrameInfosViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 10/6/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

struct StyleFrameInfoModel {
    let id: String
    let name: String
}

class StyleFrameInfosViewModel: GridViewModel {
    var itemSpacing: CGFloat { 0 }
    var scrollDirection: UICollectionView.ScrollDirection { .vertical }
    let reloadData: SignalProducer<Void, Never>
    
    let spaceFromBottom: CGFloat = 68 + 40 + 8
    let frameInfos = MutableProperty<[StyleFrameInfoModel]>([])
    let cellMapping: [String: UICollectionViewCell.Type] = ["style_frame_info_cell": StyleFrameInfoCell.self]
    let selectedFrame = MutableProperty<StyleFrameInfoModel?>(nil)
    
    init() {
        reloadData = frameInfos.producer.map { _ in }
    }
    
    func numberOfRows(in section: Int) -> Int {
        frameInfos.value.count
    }
    
    func cellIdentifier(at indexPath: IndexPath) -> String {
        "style_frame_info_cell"
    }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UICollectionViewCell {
        guard let styleFrameInfoCell = cell as? StyleFrameInfoCell else { fatalError() }
        guard let model = itemAt(indexPath: indexPath) else { return }
        styleFrameInfoCell.configure(model: model)
        if indexPath.row == frameInfos.value.count - 1 {
            styleFrameInfoCell.hideSeparator()
        }
    }
    
    func sizeForItem(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize? {
        .init(width: collectionView.frame.width, height: 40)
    }
    
    func itemAt(indexPath: IndexPath) -> StyleFrameInfoModel? {
        guard !frameInfos.value.isEmpty else { return nil }
        return frameInfos.value[indexPath.row]
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        guard let item = itemAt(indexPath: indexPath) else { return }
        selectedFrame.swap(item)
    }
}
