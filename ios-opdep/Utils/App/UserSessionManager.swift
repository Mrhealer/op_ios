//
//  UserSessionManager.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 16/05/2021.
//

import Foundation
import ReactiveSwift

struct UserAsset {
    let fullName: String?
    let phoneNumber: String?
    let address: String?
    let cityName: String?
    var nameShipping: String { fullName.asStringOrEmpty() }
    var phoneShipping: String { phoneNumber != nil ? " |\(phoneNumber.asStringOrEmpty())" : "" }
    var addressShipping: String { address != nil ? " |\(address.asStringOrEmpty())" : "" }
    var cityShipping: String { cityName != nil ? " |\(cityName.asStringOrEmpty())" : "" }
    var contactShipping: String { nameShipping + phoneShipping + addressShipping + cityShipping }
}

class UserSessionManager {
    static let shared = UserSessionManager(storage: LocalStorage())
    
    private let storage: LocalStorage
    
    let updatedUserAsset = MutableProperty<UserAsset?>(nil)
    let updatedCartsAsset = MutableProperty<[CartItemViewModel]>([])
    
    init(storage: LocalStorage) {
        self.storage = storage
    }
    
    func saveToken(_ token: String) {
        storage.setAccessToken(token)
    }
    
    func logout() {
        storage.clearAll()
    }
    
    func updateUserProfile(_ profile: UserAsset) {
        let asset = UserAsset(fullName: profile.fullName,
                              phoneNumber: profile.phoneNumber,
                              address: profile.address,
                              cityName: profile.cityName)
        updatedUserAsset.swap(asset)
    }
    
    func updateCartsAsset(_ carts: [CartItemViewModel]) {
        updatedCartsAsset.swap(carts)
    }
}
