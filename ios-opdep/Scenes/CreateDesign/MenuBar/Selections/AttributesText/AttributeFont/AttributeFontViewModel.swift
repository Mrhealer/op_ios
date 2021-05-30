//
//  AttributeFontViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/5/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class AttributeFontViewModel: GridViewModel {
    var backgroundColor: UIColor { .white }
    var itemSpacing: CGFloat { 16 }
    var padding: CGFloat { 16 }
    var itemsPerUnit: CGFloat { 4 }
    var scrollDirection: UICollectionView.ScrollDirection { .vertical }
    let reloadData: SignalProducer<Void, Never>
    
    let isSelected = MutableProperty<Bool>(false)
    let fonts = MutableProperty<[DesignImageModel]>([])
    let selectedFont = MutableProperty<DesignImageModel?>(nil)
    private let fetchFontsAction: Action<Void, [DesignImageModel], APIError>
    private let worker: AttributeFontWorker
    init(apiService: APIService) {
        worker = AttributeFontWorker(apiService: apiService)
        fetchFontsAction = Action(state: fonts) { [worker] input in
            guard input.isEmpty else { return .empty }
            return worker.fetchFontImages()
        }
        reloadData = fonts.producer.map { _ in }
        fonts <~ fetchFontsAction.values
        fetchFontsAction <~ isSelected.signal
            .filter { $0 == true }
            .map { _ in }
    }
    
    let cellMapping: [String: UICollectionViewCell.Type] = ["design_grid_cell": DesignGridCell.self]
    
    func cellIdentifier(at indexPath: IndexPath) -> String { "design_grid_cell" }
    
    func numberOfRows(in section: Int) -> Int { fonts.value.count }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UICollectionViewCell {
        guard let designCell = cell as? DesignGridCell else { fatalError() }
        designCell.backgroundColor = .black
        let model = itemAt(indexPath: indexPath)
        designCell.configure(model: model)
    }
    
    func itemAt(indexPath: IndexPath) -> DesignImageModel {
        fonts.value[indexPath.row]
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        let item = itemAt(indexPath: indexPath)
        selectedFont.swap(item)
    }
}
