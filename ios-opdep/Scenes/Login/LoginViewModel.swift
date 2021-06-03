//
//  LoginViewModel.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 27/04/2021.
//

import Foundation
import ReactiveSwift
import FirebaseAuth

class LoginViewModel: BasicViewModel {
    typealias OutputError = Error
    let errors: Signal<Error, Never>
    let isLoading: Signal<Bool, Never>
    
    let numberPhone = MutableProperty<String?>(nil)
    let dataLogin = MutableProperty<DataLogin?>(nil)
    
    let otp = MutableProperty<String?>(nil)
    let verifycationID = MutableProperty<String?>(nil)
    let isShowOtp = MutableProperty<Bool>(false)
    
    let backScreen: Action<Void, Void, Never>
    let loginAction: Action<Void, Bool, Never>
    let loginNumberPhoneAction: Action<Void, LoginNumberPhoneResponse, APIError>
    let sendOtpAction: Action<Void, String, ValidateError>
    let verificationNumberPhoneAction: Action<Void, String, ValidateError>
    let combineLoginPhoneNumber = MutableProperty<(String?, String?)>((nil, nil))
    
    let router: LoginRouter
    let worker: LoginWorker
    let apiService : APIService
    
    init(apiService: APIService,
         router: LoginRouter) {
        self.router = router
        self.worker = .init(apiService: apiService)
        self.apiService = apiService
        // Gửi mã OTP
        sendOtpAction = Action(state: numberPhone) { numberPhone in
            SignalProducer { observer, _ in
                Auth.auth().settings?.isAppVerificationDisabledForTesting = false
                Auth.auth().languageCode = "vi"
                // Send OTP to phone
                PhoneAuthProvider.provider()
                    .verifyPhoneNumber(numberPhone.asStringOrEmpty(),
                                       uiDelegate: nil,
                                       completion: { verifycationID, error in
                                        if error != nil {
                                            observer.send(error: ValidateError.incorrectPhone)
                                            observer.sendCompleted()
                                        } else {
                                            observer.send(value: verifycationID.asStringOrEmpty())
                                            observer.sendCompleted()
                                        }
                                       })
            }
        }
        // Xác nhận mã otp
        verificationNumberPhoneAction = Action(state: combineLoginPhoneNumber) { combine in
            SignalProducer { observer, _ in
                let credential = PhoneAuthProvider
                    .provider().credential(withVerificationID: combine.0.asStringOrEmpty(),
                                           verificationCode: combine.1.asStringOrEmpty())
                Auth.auth().signIn(with: credential, completion: { authData, error in
                    if error != nil {
                        observer.send(error: ValidateError.incorrectOtp)
                        observer.sendCompleted()
                    } else {
                        authData?.user.getIDToken(completion: { token, _  in
                            observer.send(value: token.asStringOrEmpty())
                            observer.sendCompleted()
                        })
                    }
                })
            }
        }
        
        loginAction = Action(state: isShowOtp) { isShowOtp in
            .init(value: isShowOtp)
        }
        
        backScreen = Action { [router] in
            router.close()
            return .init(value: ())
        }
        
        sendOtpAction.values.observeValues {
            print("Verification: \($0)")
        }
        
        verificationNumberPhoneAction.values.observeValues {
            print("Token: \($0)")
        }

        loginNumberPhoneAction = Action(state: dataLogin) {
            [worker] dataLogin in worker.login(with: dataLogin!)
        }
        
        
        loginNumberPhoneAction.values.observeValues { [router] in
            if let data = $0.data {
                apiService.keyStore.setUserId(data.id.toString())
                router.close()
            }
        }
        
        isShowOtp <~ sendOtpAction.values.map { _ in true }
        verifycationID <~ sendOtpAction.values
        sendOtpAction <~ loginAction.values.filter { !$0 }.map { _ in }
        verificationNumberPhoneAction <~ loginAction.values.filter { $0 }.map { _ in }
        loginNumberPhoneAction <~ verificationNumberPhoneAction.values.map { _ in }
        
        combineLoginPhoneNumber <~ SignalProducer.combineLatest(verifycationID.producer,
                                                                otp.producer)
        
        errors = Signal.merge(sendOtpAction.errors.map { $0 },
                              verificationNumberPhoneAction.errors.map { $0 },
                              loginNumberPhoneAction.errors.map { $0 })
        isLoading = Signal.merge(sendOtpAction.isExecuting.signal,
                                 verificationNumberPhoneAction.isExecuting.signal,
                                 loginNumberPhoneAction.isExecuting.signal)
    }
    
    func loginWithSocial() {
        loginNumberPhoneAction.apply().start()
    }
}

enum AccountType {
    case gg
    case fb
    case ap
    case email
    
    var value: String {
        switch self {
        case .gg : return "gg"
        case .fb: return "fb"
        case .ap: return "ap"
        case .email: return "email"
        }
    }
}

class DataLogin {
    var name : String?
    var fb_id : String?
    var email_google : String?
    var phone_number_firebase : String?
    var type : String
    
    
    init(name: String, fb_id :String, email_google : String, phone_number_firebase: String, type :String) {
        self.name = name
        self.fb_id = fb_id
        self.email_google = email_google
        self.phone_number_firebase = phone_number_firebase
        self.type = type
    }
}
