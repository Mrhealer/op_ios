//
//  UploadDesignViewModel.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 12/05/2021.
//

import Foundation
import ReactiveSwift

class BuyViewModel: BasicViewModel {
    
    typealias OutputError = APIError
    let errors: Signal<APIError, Never>
    let isLoading: Signal<Bool, Never>
    
    let productModel: Property<ProductModel>
    let outPutFile: Property<OutPutFileModel>
    let router: BuyRouter
    let worker: BuyWorker
    
    private let uploadResponse = MutableProperty<UploadFilesResponse?>(nil)
    let buyAction: Action<Bool, UploadFilesResponse, APIError>
    let checkLoginAction: Action<Void, Bool, Never>
    let loginAction: Action<Bool, Bool, Never>
    
    init (productModel: ProductModel,
          outputFile: OutPutFileModel,
          apiService: APIService,
          router: BuyRouter) {
        self.outPutFile = Property(value: outputFile)
        self.productModel = Property(value: productModel)
        self.router = router
        worker = BuyWorker(apiService: apiService)
        
        checkLoginAction = Action {
            if apiService.keyStore.userId != nil {
                return .init(value: true)
            } else {
                return .init(value: false)
            }
        }
        
        loginAction = Action { [router] _ in
            router.presentSignIn()
            return .empty
        }
        
        buyAction = Action { [worker, outPutFile, productModel] _ in
            guard let userId = apiService.keyStore.userId,
                let photo = outPutFile.value.photo,
                let preview = outPutFile.value.preview,
                let printFile = outPutFile.value.print else {
                    return .empty
            }
            return worker.uploadFiles(with: userId,
                                      productId: productModel.id,
                                      photo: photo,
                                      preview: preview,
                                      printFile: printFile)
        }
        
        buyAction.values.observeValues { [router] in
            if $0.status == 0 {
                guard let userId = apiService.keyStore.userId else { return }
                router.navigateToCart(userId)
            }
        }
        
        buyAction <~ checkLoginAction.values.filter { $0 == true }
        loginAction <~ checkLoginAction.values.filter { $0 == false }
        
        isLoading = buyAction.isExecuting.signal
        errors = buyAction.errors.map { $0 }
    }
}
