//
//  ShoppingCartViewModel.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 11/05/2021.
//

import Foundation
import ReactiveSwift

enum TypeScreen {
    case root
    case navigate
}

class ShoppingCartViewModel: ListViewModel, BasicViewModel {
    typealias OutputError = APIError
    let errors: Signal<APIError, Never>
    let isLoading: Signal<Bool, Never>
    let reloadData: Signal<Void, Never>
    let reloadRow: Signal<IndexPath?, Never> = .empty
    
    let userId: Property<String>
    let asset = MutableProperty<[CartItemViewModel]>([])
    let totalPrice = MutableProperty<String?>(nil)
    let shippingPrice = MutableProperty<String?>(nil)
    let quantityProduct = MutableProperty<String?>(nil)
    
    let shoppingCart = MutableProperty<[CartItemViewModel]>([])
    let selectedItem = MutableProperty<CartItemViewModel?>(nil)
    
    let saveCartsAssetAction: Action<ShoppingCartResponse, Void, Never>
    let navigateToDiscountAction: Action<Void, Void, Never>
    let deleteOrderAction: Action<String, DeleteOrderResponse, APIError>
    let fetchDataShoppingCartAction: Action<Void, ShoppingCartResponse, APIError>
    
    let typeScreen: TypeScreen
    private let router: ShoppingCartRouter
    private let worker: ShoppingCartWorker
    
    init(apiService: APIService,
         typeScreen: TypeScreen,
         router: ShoppingCartRouter) {
        self.userId = Property(value: apiService.keyStore.userId.asStringOrEmpty())
        self.router = router
        self.typeScreen = typeScreen
        self.worker = .init(apiService: apiService)
        
        fetchDataShoppingCartAction = Action(state: userId) { [worker] userId in
            worker.fetchDataShoppingCart(userId: userId)
        }
        
        saveCartsAssetAction = Action { carts in
            let carts = carts.carts.map { CartItemViewModel(model: $0, apiService: APIService.shared) }
            UserSessionManager.shared.updateCartsAsset(carts)
            return .init(value: ())
        }
        
        shoppingCart <~ UserSessionManager.shared.updatedCartsAsset.producer
        
        deleteOrderAction = Action(state: self.userId) { [worker] userId, input in
            let orderId = input
            return worker.deleteOrder(with: userId,
                                      orderId: orderId)
        }
        
        navigateToDiscountAction = Action { [router, userId] in
            router.navigateToDiscount(userId: userId.value)
            return .init(value: ())
        }
                        
//        shoppingCart <~ fetchDataShoppingCartAction.values.map { response in
//            response.carts.map { CartItemViewModel(model: $0, apiService: APIService.shared) }
//        }
        
        quantityProduct <~ shoppingCart.signal.map { "x\($0.count)"}
        
        totalPrice <~ shoppingCart.producer.map { response in
            UtilityPrice.mathTotalPrice(data: response)
        }
        
        shippingPrice <~ fetchDataShoppingCartAction.values
            .map { $0.shippingPrice }
        
        saveCartsAssetAction <~ fetchDataShoppingCartAction.values
        fetchDataShoppingCartAction <~ deleteOrderAction.values.map { _ in }
        isLoading = Signal.merge(fetchDataShoppingCartAction.isExecuting.signal,
                                 deleteOrderAction.isExecuting.signal)
        errors = Signal.merge(fetchDataShoppingCartAction.errors.map { $0 },
                              deleteOrderAction.errors.map { $0 })
        reloadData = shoppingCart.signal.map { _ in }
    }
    
    func fetchDataShoppingCart() {
        fetchDataShoppingCartAction.apply().start()
    }

    func didSelectRowAt(indexPath: IndexPath) {
        selectedItem.value = content(at: indexPath)
    }
    
    private func content(at indexPath: IndexPath) -> CartItemViewModel {
        shoppingCart.value[indexPath.row]
    }
    
    let cellMapping: [String: UITableViewCell.Type] = ["cart_item_cell": CartItemViewCell.self]
    
    let style: UITableView.Style = .plain
    
    func numberOfSections() -> Int { 1 }
    
    func numberOfRows(in section: Int) -> Int {
        shoppingCart.value.count
    }
    
    func cellIdentifier(at indexPath: IndexPath) -> String {
        "cart_item_cell"
    }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UITableViewCell {
        guard let cell = cell as? CartItemViewCell else { fatalError() }
        let viewModel = content(at: indexPath)
        deleteOrderAction <~ viewModel.deleteAction.values
            .take(until: cell.reactive.prepareForReuse)
            .map { $0.id.toString() }
        cell.configure(viewModel: viewModel)
    }
    
    func willDisplayCell(_ cell: UITableViewCell, at indexPath: IndexPath) {}
    
    func didEndDisplayingCell(_ cell: UITableViewCell, at indexPath: IndexPath) {}
}
