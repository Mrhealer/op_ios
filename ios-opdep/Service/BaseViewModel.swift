//
//  BaseViewModel.swift
//  VoiceApp
//
//  Created by VMO on 7/31/20.
//  Copyright © 2020 VoiceApp. All rights reserved.
//

import UIKit
import RxSwift

// API Name, such as login, register ...
typealias ApiName = String

// Response Subject
typealias ApiResponseSubject = (api: ApiName, isRequestSuccess: Bool, message: String?)

class BaseViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    var message = PublishSubject<String>()
    var responseSubject = PublishSubject<ApiResponseSubject>()
    var isShowLoading = PublishSubject<Bool>()

}
