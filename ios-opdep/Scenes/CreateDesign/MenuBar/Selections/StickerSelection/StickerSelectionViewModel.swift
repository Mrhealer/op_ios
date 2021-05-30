//
//  StickerSelectionViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/21/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class StickerSelectionViewModel {
    let isSelected = MutableProperty<Bool>(false)
    let categoryBarViewModel: CategoryBarViewModel
    let pagingStickerViewModel: PagingStickerViewModel
    let fetchCategoriesAction: Action<Void, [ImageCategoryModel], APIError>
    let takePhotoAction: Action<Void, Void, Never>
    let worker: StickerSelectionWorker
    var selectedSticker: Signal<URL?, Never> { pagingStickerViewModel.selectedSticker.signal }
    
    init(apiService: APIService) {
        worker = StickerSelectionWorker(apiService: apiService)
        categoryBarViewModel = CategoryBarViewModel(itemsForDisplay: nil,
                                                    backgroundColor: UIColor.Editor.bgMenuSelection)
        pagingStickerViewModel = PagingStickerViewModel()
        fetchCategoriesAction = Action { [worker] in
            return worker.fetchCategories()
        }
        takePhotoAction = Action { _ in .init(value: ()) }
        pagingStickerViewModel.scrollToItem = categoryBarViewModel.currentIndexPath.signal
        categoryBarViewModel.categories <~ fetchCategoriesAction.values.map {
            $0.map { CategoryBarItemViewModel(type: .template, model: $0) }
                                           }
        pagingStickerViewModel.categories <~ fetchCategoriesAction.values.map {
            $0.map { CategoryBarItemViewModel(type: .template, model: $0) }
        }
        Signal.merge(pagingStickerViewModel.currentIndexPath.signal.skipNil(),
                     fetchCategoriesAction.completed.map { IndexPath(row: 0,
                                                                     section: 0)
        }).observeValues { [categoryBarViewModel] in
            categoryBarViewModel.didSelectItemAt(indexPath: $0)
        }
    }
    
    func fetchImages() {
        guard pagingStickerViewModel.categories.value.isEmpty else { return }
        fetchCategoriesAction.apply().start()
    }
}
