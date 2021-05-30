//
//  DiscountViewModel.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 14/05/2021.
//

import Foundation
import ReactiveSwift
import FirebaseAuth

class DiscountViewModel: BasicViewModel {
    typealias OutputError = Error
    let errors: Signal<Error, Never>
    let isLoading: Signal<Bool, Never>

    let userId: Property<String>
    let asset = MutableProperty<UserAsset?>(nil)
    // Data để hiện thị ra màn hình
    let type = MutableProperty<TypeFetchDataDiscount>(.normal)
    let discountCode = MutableProperty<String?>(nil)
    let totalPrice = MutableProperty<String?>(nil)
    let addressShipping = MutableProperty<String?>(nil)
    let totalPriceShipping = MutableProperty<String?>(nil)
    // Data để kiểm tra địa chỉ gửi hàng
    let fullName = MutableProperty<String?>(nil)
    let email = MutableProperty<String?>(nil)
    let phoneNumber = MutableProperty<String?>(nil)
    let address = MutableProperty<String?>(nil)
    let city = MutableProperty<String?>(nil)
    // Action
    let navigateToProfileAction: Action<Void, Void, Never>
    let confirmDiscountAction: Action<Void, Void, Never>
    let fetchDataDiscountAction: Action<Void, DiscountResponse, APIError>
    let validateInfoShippingAction: Action<Void, (String, String, String, String, String), ValidateError>
    let submitOrderAction: Action<(String, String, String, String, String), SubmitOrderResponse, APIError>
    let confirmOrderAction: Action<SubmitOrderResponse, ConfirmOrderResponse, APIError>
    // Combine input action
    let combineInputDiscount = MutableProperty<(String, String?)>(("", nil))
    let inputSubmitOrder = MutableProperty<(String, String?)>(("", nil))
    let infoShipping =
        MutableProperty<(String?, String?, String?, String?, String?)>((nil, nil, nil, nil, nil))
    
    let router: DiscountRouter
    let worker: DiscountWorker
    
    init(userId: String,
         apiService: APIService,
         router: DiscountRouter) {
        self.router = router
        self.userId = Property(value: userId)
        self.worker = .init(apiService: apiService)
        asset <~ UserSessionManager.shared.updatedUserAsset

        fetchDataDiscountAction = Action(state: combineInputDiscount) { [worker] combine in
            worker.fetchDataDiscount(userId: combine.0,
                                     codeNumber: combine.1)
        }
        
        confirmDiscountAction = Action { [type] in
            type.swap(.discount)
            return .init(value: ())
        }
        
        validateInfoShippingAction = Action(state: infoShipping) { info in
            let (fullName, email, phoneNumber, address, city) = info
            if let validate = CommonUtility.isValidFullName(fullName) { return .init(error: validate) }
            if let validate = CommonUtility.isValidPhone(phoneNumber) { return .init(error: validate) }
            if let validate = CommonUtility.isValidEmpty(address, error: .emptyAddress)
            { return .init(error: validate) }
            if let validate = CommonUtility.isValidEmpty(city, error: .emptyCity)
            { return .init(error: validate) }
            return .init(value: (fullName.asStringOrEmpty(),
                                 email.asStringOrEmpty(),
                                 phoneNumber.asStringOrEmpty(),
                                 address.asStringOrEmpty(),
                                 city.asStringOrEmpty()))
        }
        
        submitOrderAction = Action(state: inputSubmitOrder) { [worker] input, infoShipping in
            let (userId, codeNumber) = input
            let (fullName, email, phoneNumber, address, city) = infoShipping
            return worker.submitOrder(with: userId, phone: phoneNumber,
                                      city: city, address: address,
                                      email: email, realName: fullName,
                                      codeNumber: codeNumber.asStringOrEmpty())
        }
        
        confirmOrderAction = Action { [worker] input in
            worker.confirmOrder(with: input.data.id.toString(),
                                status: AppConstants.OrderStatusNumber.CONFIRMED)
        }
        
        navigateToProfileAction = Action(state: self.userId) { [router] userId in
            router.navigateToProfile(userId: userId)
            return .init(value: ())
        }

        totalPrice <~ fetchDataDiscountAction.values.map { $0.data?.totalPrice  }
        addressShipping <~ Signal.merge(fetchDataDiscountAction.values.map { $0.profile?.contactShipping },
                                        asset.signal.map { $0?.contactShipping })
        totalPriceShipping <~ fetchDataDiscountAction.values.map { $0.data?.totalPriceShipping }
        fullName <~ fetchDataDiscountAction.values.map { $0.profile?.fullName }
        email <~ fetchDataDiscountAction.values.map { $0.profile?.email1 }
        phoneNumber <~ fetchDataDiscountAction.values.map { $0.profile?.phoneNumber }
        address <~ fetchDataDiscountAction.values.map { $0.profile?.address }
        city <~ fetchDataDiscountAction.values.map { $0.profile?.cityName }
        
        submitOrderAction <~ validateInfoShippingAction.values
        fetchDataDiscountAction <~ confirmDiscountAction.values
        confirmOrderAction <~ submitOrderAction.values
        
        inputSubmitOrder <~ self.userId.producer.combineLatest(with: discountCode.producer)
        combineInputDiscount <~ self.userId.producer.combineLatest(with: discountCode.producer)
        infoShipping <~ SignalProducer.combineLatest(fullName.producer,
                                                     email.producer,
                                                     phoneNumber.producer,
                                                     address.producer,
                                                     city.producer)
        
        errors = Signal.merge(fetchDataDiscountAction.errors.map { $0 },
                              validateInfoShippingAction.errors.map { $0 },
                              submitOrderAction.errors.map { $0 },
                              confirmOrderAction.errors.map { $0 })
        isLoading = Signal.merge(fetchDataDiscountAction.isExecuting.signal,
                                 submitOrderAction.isExecuting.signal,
                                 confirmOrderAction.isExecuting.signal)
    }
    
    func fetchDataDiscount() {
        type.swap(.normal)
        fetchDataDiscountAction.apply().start()
    }
    
    func backToHome() {
        UserSessionManager.shared.updateCartsAsset([])
        router.backToHome()
    }
}

enum TypeFetchDataDiscount {
    case normal
    case discount
}
