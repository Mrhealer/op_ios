//
//  OrderHistoryViewModel.swift
//  OPOS
//
//  Created by Hoc Nguyen on 7/16/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class OrderHistoryViewModel: ListViewModel, BasicViewModel {
    typealias OutputError = APIError
    let errors: Signal<APIError, Never>
    let isLoading: Signal<Bool, Never>
    var reloadRow: Signal<IndexPath?, Never> = .empty
    
    let reloadData: Signal<Void, Never>
    let userId: Property<String>
    let orderHistory: MutableProperty<[OrderHistoryCellViewModel]>
    let fetchOrderHistoryAction: Action<Void, [OrderHistoryResponse], APIError>
    private let worker: OrderHistoryWorker
    private let router: OrderHistoryRouter
    
    init(urserId: String,
         apiService: APIService,
         router: OrderHistoryRouter) {
        self.userId = Property(value: urserId)
        worker = OrderHistoryWorker(apiService: apiService)
        self.router = router
        fetchOrderHistoryAction = Action(state: self.userId) { [worker] userId in
            worker.fetchOrderHistory(with: userId)
        }
        
        orderHistory = MutableProperty([])
        orderHistory <~ fetchOrderHistoryAction.values.map { response in
            response.map { OrderHistoryCellViewModel(model: $0,
                                                     apiService: APIService.shared,
                                                     router: router)
            }
        }
        
        isLoading = fetchOrderHistoryAction.isExecuting.signal
        errors = fetchOrderHistoryAction.errors
        reloadData = orderHistory.signal.map { _ in }
    }
    
    func fetchOrderHistory() {
        fetchOrderHistoryAction.apply().start()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {}
    
    private func content(at indexPath: IndexPath) -> OrderHistoryCellViewModel {
        orderHistory.value[indexPath.row]
    }
    
    let cellMapping: [String: UITableViewCell.Type] = ["order_history_cell": OrderHistoryCell.self]
    
    let style: UITableView.Style = .plain
    
    func numberOfSections() -> Int { 1 }
    
    func numberOfRows(in section: Int) -> Int {
        orderHistory.value.count
    }
    
    func cellIdentifier(at indexPath: IndexPath) -> String {
        "order_history_cell"
    }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UITableViewCell {
        guard let orderHistoryCell = cell as? OrderHistoryCell else { fatalError() }
        let viewModel = content(at: indexPath)
        orderHistoryCell.configure(viewModel: viewModel)
    }
    
    func willDisplayCell(_ cell: UITableViewCell, at indexPath: IndexPath) {}
    
    func didEndDisplayingCell(_ cell: UITableViewCell, at indexPath: IndexPath) {}
    
}
