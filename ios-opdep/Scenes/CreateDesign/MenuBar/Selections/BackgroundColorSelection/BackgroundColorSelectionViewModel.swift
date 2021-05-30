//
//  File.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 06/05/2021.
//

import Foundation
import ReactiveSwift

class BackgroundColorSelectionViewModel {
    let isSelected = MutableProperty<Bool>(false)
    let imageContext = MutableProperty<ImageContext>(.background)
    
    // MARK: Output Signal to binding design layer
    let selectedColorAction: Action<UIImage?, (UIImage?, ImageContext), Never>
    
    let designGridViewModel: DesignGridViewModel
    let worker: StyleFrameSelectionWorker
    init(apiService: APIService) {
        worker = .init(apiService: apiService)
        
        designGridViewModel = .init(backgroundColor: UIColor.Basic.white,
                                    scrollDirection: .vertical,
                                    itemsPerUnit: 7,
                                    padding: 8,
                                    itemSpacing: 8)
        
        let array: [DesignImageModel] = AppConstants.colors
            .map { .init(id: 1, imageLink: $0.hexColor,
                         thumbLink: nil, categoryId: nil, info: nil) }
        designGridViewModel.designs.swap(array)
        
        selectedColorAction = Action(state: imageContext) { context, input in
            return .init(value: (input, context))
        }
        
        selectedColorAction <~ designGridViewModel.selectedDesign.map { $0?.coloredImage }
    }
}
