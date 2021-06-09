//
//  HomeViewModel.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 24/04/2021.
//

import Foundation
import ReactiveSwift

class HomeViewModel: ListViewModel, BasicViewModel {
    typealias OutputError = APIError
    let errors: Signal<APIError, Never>
    let isLoading: Signal<Bool, Never>
    let reloadData: Signal<Void, Never>
    let reloadRow: Signal<IndexPath?, Never> = .empty
    
    let categories = MutableProperty<[Categories]>([])
    let selectedItem = MutableProperty<Categories?>(nil)
    
    let fetchDataCategoryAction: Action<Void, [Categories], APIError>
    
    private let router: HomeRouter
    private let worker: HomeWorker
    var viewController: UIViewController?
    
    init(apiService: APIService,
         router: HomeRouter) {
        self.router = router
        self.worker = .init(apiService: apiService)
        
        fetchDataCategoryAction = Action { [worker] in
            worker.fetchDataCategory()
        }
                
        categories <~ fetchDataCategoryAction.values
        
        isLoading = Signal.merge(fetchDataCategoryAction.isExecuting.signal)
        errors = Signal.merge(fetchDataCategoryAction.errors.map { $0 })
        reloadData = categories.signal.map { _ in }
    }
    
    func fetchDataCategory() {
        fetchDataCategoryAction.apply().start()
    }

    func didSelectRowAt(indexPath: IndexPath) {
        selectedItem.value = content(at: indexPath)
        router.navigateToProducts(category: content(at: indexPath))
    }
    
    private func content(at indexPath: IndexPath) -> Categories {
        categories.value[indexPath.row]
    }
    
    let cellMapping: [String: UITableViewCell.Type] = ["home_cell": HomeCell.self, "ads_cell": AdsTableViewCell.self]
    
    let style: UITableView.Style = .plain
    
    func numberOfSections() -> Int { 1 }
    
    func numberOfRows(in section: Int) -> Int {
        categories.value.count
    }
    
    func cellIdentifier(at indexPath: IndexPath) -> String {
        let viewModel = content(at: indexPath)
        return viewModel.type == 1 ? "home_cell" : "ads_cell"
    }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UITableViewCell {
        if let cell = cell as? HomeCell {
            let viewModel = content(at: indexPath)
            cell.configure(viewModel: viewModel)
        }else if let cell = cell as? AdsTableViewCell,let viewController = self.viewController{
            cell.loadAd(rootViewController: viewController)
        }else{
            fatalError()
        }
      
    }
    
    func willDisplayCell(_ cell: UITableViewCell, at indexPath: IndexPath) {}
    
    func didEndDisplayingCell(_ cell: UITableViewCell, at indexPath: IndexPath) {}
    
}

