//
//  ProfileWorker.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 16/05/2021.
//

import Foundation
import ReactiveSwift

class ProfileWorker {
    
    let apiService: APIService
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchProfile(with userId: String) -> SignalProducer<Profile, APIError> {
        let request = ProfileRequest(userId: userId)
        return apiService.reactive.response(of: request)
    }
    
    func updateProfile(with userId: String,
                       fullName: String,
                       phoneNumber: String,
                       address: String,
                       cityId: String) -> SignalProducer<UpdateProfileResponse, APIError> {
        let request = UpdateProfileRequest(userId: userId,
                                           fullName: fullName,
                                           phoneNumber: phoneNumber,
                                           address: address,
                                           cityId: cityId)
        return apiService.reactive.response(of: request)
    }
}
