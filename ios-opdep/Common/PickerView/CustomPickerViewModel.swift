//
//  ChoosePickerViewModel.swift
//  OPOS
//
//  Created by Nguyễn Quang on 10/2/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class CustomPickerViewModel: BasicViewModel {
    typealias OutputError = Error
    let errors: Signal<Error, Never>
    let isLoading: Signal<Bool, Never>
    
    let dataPicker = MutableProperty<[Cities]>([])
    let title = MutableProperty<String>("")
    let nameSelected = MutableProperty<String?>(nil)
    let idSelected = MutableProperty<Int?>(nil)
    
    let fetchCityAction: Action<Void, [Cities], APIError>
    let cancelAction: Action<Void, Void, Never>
    let chooseAction: Action<Void, (String?, Int?), Never>
    let combineChooseAction = MutableProperty<(String?, Int?)>((nil, nil))
    
    let worker: CustomPickerWorker
    
    init(apiService: APIService) {
        
        worker = CustomPickerWorker(apiService: apiService)
        
        fetchCityAction = Action { [worker] in
            worker.fetchCities()
        }
        
        dataPicker <~ fetchCityAction.values
        
        cancelAction = Action {
            .init(value: ())
        }
        
        chooseAction = Action(state: combineChooseAction) { combine in
            .init(value: (combine.0, combine.1))
        }
        
        combineChooseAction <~ SignalProducer.combineLatest(nameSelected.producer,
                                                            idSelected.producer)
        
        isLoading = Signal.merge(fetchCityAction.isExecuting.signal)
        errors = Signal.merge(fetchCityAction.errors.map { $0 })
    }
    
    func fetchCity() {
        fetchCityAction.apply().start()
    }
}
