//
//  ProductViewModel.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 03/05/2021.
//

import Foundation
import ReactiveSwift

class ProductViewModel: BasicViewModel {
    typealias OutputError = Error
    let errors: Signal<Error, Never>
    let isLoading: Signal<Bool, Never>
    
    let categoryId: Property<String>
    let categoryName: Property<String>
    
    let fetchDataProductAction: Action<Void, [ProductModel], APIError>
    let navigateMyDesignAction: Action<ProductModel, ProductModel, Never>
    let downloadImagesAction: Action<ProductModel, (ProductModel, [UIImage?]), ImageDownloadError>
    let productGridViewModel: ProductGridViewModel
    
    let imageDownloadWorker = ImageDownloadWorker()
    let router: ProductRouter
    let worker: ProductWorker
    
    init(category: Categories,
         router: ProductRouter,
         apiService: APIService) {
        self.router = router
        self.categoryId = Property(value: category.id.toString())
        self.categoryName = Property(value: category.name)
        self.worker = .init(apiService: apiService)
        
        productGridViewModel = .init(itemsForDisplay: 2,
                                     backgroundColor: .clear)
        
        fetchDataProductAction = Action(state: categoryId) { [worker] categoryId in
            worker.fetchProducts(categoryId: categoryId)
        }
        
        navigateMyDesignAction = Action { product in
            return .init(value: product)
        }
        
        downloadImagesAction = Action { [imageDownloadWorker] product in
            var producers: [SignalProducer<UIImage?, ImageDownloadError>] = []
            producers.append(contentsOf: [imageDownloadWorker.fetchImage(url: product.backLayerImageUrl),
                                          imageDownloadWorker.fetchImage(url: product.middleLayerImageUrl),
                                          imageDownloadWorker.fetchImage(url: product.frontLayerImageUrl)])
            return SignalProducer<UIImage?, ImageDownloadError>.zip(producers).map { (product, $0) }
        }

        downloadImagesAction.values.observeValues { [router] in
             router.navigateToCreateDesign(product: $0.0,
                                           resources: $0.1)
        }
         
        downloadImagesAction <~ navigateMyDesignAction.values
        navigateMyDesignAction <~ productGridViewModel.selectedToItem.values.skipNil()
        productGridViewModel.products <~ fetchDataProductAction.values
        
        isLoading = Signal.merge(fetchDataProductAction.isExecuting.signal,
                                 downloadImagesAction.isExecuting.signal)
        errors = Signal.merge(fetchDataProductAction.errors.map { $0 },
                              downloadImagesAction.errors.map { $0 })
    }
    
    func fetchDataProduct() {
        fetchDataProductAction.apply().start()
    }
}
