//
//  ImageSelectionViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/20/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

enum ImageContext {
    // image for background
    case background
    // image for frame
    case frame
    // image for style frame
    case styleFrame
}

class ImageSelectionViewModel {
    let isSelected = MutableProperty<Bool>(false)
    let imageContext = MutableProperty<ImageContext>(.background)
    let categoryBarViewModel: CategoryBarViewModel
    let designGridViewModel: DesignGridViewModel
    let worker: ImageSelectionWorker
    let fetchCategoriesAction: Action<Void, [ImageCategoryModel], APIError>
    let showImageEffectsAction: Action<Void, ImageContext, Never>
    
    // image action
    let takePhotoAction: Action<Void, Void, Never>
    let takeCameraAction: Action<Void, Void, Never>
    let resetPhotoAction: Action<Void, (Void, ImageContext), Never>
    let rotatePhotoAction: Action<Void, (Void, ImageContext), Never>
    let flipPhotoAction: Action<Void, (Void, ImageContext), Never>
    let hideAction: Action<Void, Void, Never>
    
    // MARK: Output Signal to binding design layer
    let selectedImageAction: Action<URL?, (URL?, ImageContext), Never>
    let selectedColorAction: Action<UIImage?, (UIImage?, ImageContext), Never>
    
    init(apiService: APIService) {
        worker = ImageSelectionWorker(apiService: apiService)
        categoryBarViewModel = CategoryBarViewModel(itemsForDisplay: 5,
                                                    backgroundColor: UIColor.Editor.bgMenuSelection,
                                                    categories: [
                                                        CategoryBarItemViewModel(type: .user,
                                                                                 model: .init(id: -1,
                                                                                              title: Localize.Editor.editorYourPhoto,
                                                                                               icon: nil,
                                                                                               type: -1,
                                                                                               items: nil),
                                                                                 isSelected: true)])
        designGridViewModel = .init(backgroundColor: .white,
                                    scrollDirection: .vertical,
                                    itemsPerUnit: 4,
                                    padding: 16,
                                    itemSpacing: 16)
        fetchCategoriesAction = Action(state: categoryBarViewModel.categories) { [worker] input in
            guard input.count == 1 else { return .empty }
            return worker.fetchCategories()
        }
        
        selectedImageAction = Action(state: imageContext) { context, input in
            return .init(value: (input, context))
        }
        
        selectedColorAction = Action(state: imageContext) { context, input in
            return .init(value: (input, context))
        }
        
        showImageEffectsAction = Action(state: imageContext) { .init(value: $0) }
        
        takePhotoAction = Action { .init(value: $0) }
        takeCameraAction = Action { .init(value: $0) }
        resetPhotoAction = Action(state: imageContext) { .init(value:($1, $0)) }
        rotatePhotoAction = Action(state: imageContext) { .init(value:($1, $0)) }
        flipPhotoAction = Action(state: imageContext) { .init(value:($1, $0)) }
        hideAction = Action { .init(value: $0) }
        
        categoryBarViewModel.categories <~ fetchCategoriesAction.values.map {
            var temp: [CategoryBarItemViewModel] = []
            temp.append(CategoryBarItemViewModel(type: .user,
                                                 model: .init(id: -1,
                                                              title: Localize.Editor.editorYourPhoto,
                                                              icon: nil,
                                                              type: -1,
                                                              items: nil)))
            temp.append(contentsOf: $0.prefix(4).map { CategoryBarItemViewModel(type: .template,
                                                                                model: $0) })
            return temp
        }
        
        designGridViewModel.designs <~ categoryBarViewModel.selectedCategory.signal
            .skipNil()
            .filter { $0.type == .template }
            .map { $0.model.value.images }
        
        fetchCategoriesAction.completed.observeValues { [categoryBarViewModel] in
            categoryBarViewModel.didSelectItemAt(indexPath: IndexPath(row: 0,
                                                                      section: 0))
        }
        
        selectedImageAction <~ designGridViewModel.selectedDesign.map { $0?.imageUrl
        }
        selectedColorAction <~ designGridViewModel.selectedDesign.map { $0?.coloredImage
        }
        isSelected <~ hideAction.values.map { _ in false }
    }
    
    func fetchDesigns() {
        fetchCategoriesAction.apply().start()
    }
}
