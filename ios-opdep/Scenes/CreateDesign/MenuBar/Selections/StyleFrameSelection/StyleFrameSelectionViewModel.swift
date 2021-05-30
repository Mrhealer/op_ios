//
//  StyleFrameSelectionViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/28/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class StyleFrameSelectionViewModel {
    let isSelected = MutableProperty<Bool>(false)
    let designGridViewModel: DesignGridViewModel
    let insertImageAction: Action<Void, Void, Never>
    let fetchFramesAction: Action<Void, [DesignImageModel], APIError>
    
    var selectedFrame: Signal<URL, Never> { designGridViewModel.selectedDesign.signal
        .skipNil()
        .map { $0.imageUrl }
        .skipNil() }
    
    let worker: StyleFrameSelectionWorker
    init(apiService: APIService) {
        worker = .init(apiService: apiService)
        designGridViewModel = .init(backgroundColor: .white,
                                    scrollDirection: .vertical,
                                    itemsPerUnit: 4,
                                    padding: 16,
                                    itemSpacing: 16)
        insertImageAction = Action { .init(value: ()) }
        fetchFramesAction = Action(state: designGridViewModel.designs) { [worker] in
            guard $0.isEmpty else { return .empty }
            return worker.fetchFrames()
        }
        designGridViewModel.designs <~ fetchFramesAction.values
    }
    
    func fetchFrames() {
        fetchFramesAction.apply().start()
    }
}
