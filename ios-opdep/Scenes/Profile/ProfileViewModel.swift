//
//  ProfileViewModel.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 16/05/2021.
//

import Foundation
import ReactiveSwift

class ProfileViewModel: ListViewModel, BasicViewModel {
    typealias OutputError = Error
    let errors: Signal<Error, Never>
    let isLoading: Signal<Bool, Never>
    let reloadData: Signal<Void, Never>
    let reloadRow: Signal<IndexPath?, Never> = .empty
    
    let userId: Property<String>
    let fullName = MutableProperty<String?>(nil)
    let phoneNumber = MutableProperty<String?>(nil)
    let address = MutableProperty<String?>(nil)
    let city = MutableProperty<String?>(nil)
    let cityId = MutableProperty<Int?>(nil)
        
    private let profile: MutableProperty<[ProfileItemModel]>
    private let profileResponse = MutableProperty<Profile?>(nil)
    
    let fetchProfileAction: Action<Void, Profile, APIError>
    let saveProfileAction: Action<Void, Void, Never>
    let validateInputProfileAction: Action<Void, (String, String, String, Int), ValidateError>
    let saveAction: Action<(String, String, String, Int), UpdateProfileResponse, APIError>
    let infoProfile = MutableProperty<(String?, String?, String?, Int?)>((nil, nil, nil, nil))
    let userAsset = MutableProperty<(String?, String?, String?, String?)>((nil, nil, nil, nil))
    
    let customPickerViewModel: CustomPickerViewModel
    private let worker: ProfileWorker
    private let router: ProfileRouter
    
    init(urserId: String,
         apiService: APIService,
         router: ProfileRouter) {
        self.userId = Property(value: urserId)
        customPickerViewModel = .init(apiService: apiService)
        worker = ProfileWorker(apiService: apiService)
        self.router = router
        
        validateInputProfileAction = Action(state: infoProfile) { info in
            let (fullName, phoneNumber, address, city) = info
            if let validate = CommonUtility.isValidFullName(fullName) { return .init(error: validate) }
            if let validate = CommonUtility.isValidPhone(phoneNumber) { return .init(error: validate) }
            if let validate = CommonUtility.isValidEmpty(address, error: .emptyAddress)
            { return .init(error: validate) }
            guard let cityId = city else { return .init(error: ValidateError.emptyCity) }
            return .init(value: (fullName.asStringOrEmpty(),
                                 phoneNumber.asStringOrEmpty(),
                                 address.asStringOrEmpty(),
                                 cityId))
        }

        fetchProfileAction = Action(state: userId) { [worker] userId in
            worker.fetchProfile(with: userId)
        }
        
        profileResponse <~ fetchProfileAction.values
        
        fullName    <~ profileResponse.signal.map { $0?.fullName }
        phoneNumber <~ profileResponse.signal.map { $0?.phoneNumber }
        address     <~ profileResponse.signal.map { $0?.address }
        city        <~ Signal.merge(profileResponse.signal.map { $0?.cityName },
                                    customPickerViewModel.chooseAction.values.map { $0.0 })
        cityId      <~ Signal.merge(profileResponse.signal.map { $0?.cityId },
                                    customPickerViewModel.chooseAction.values.map { $0.1 })
        
        //Action save profile
        saveAction = Action(state: userId) { [worker] userId, input in
            worker.updateProfile(with: userId,
                                 fullName: input.0,
                                 phoneNumber: input.1,
                                 address: input.2,
                                 cityId: input.3.toString())
        }
        
        saveProfileAction = Action(state: userAsset) { userAsset in
            let (fullName, phoneNumber, address, city) = userAsset
            let profile: UserAsset = UserAsset(fullName: fullName, phoneNumber: phoneNumber,
                                               address: address, cityName: city)
            UserSessionManager.shared.updateUserProfile(profile)
            return .init(value: ())
        }

        
        saveAction <~ validateInputProfileAction.values
        saveProfileAction <~ saveAction.values.map { _ in }

        profile = MutableProperty([ProfileItemModel(profile: .fullName),
                                   ProfileItemModel(profile: .phoneNumber),
                                   ProfileItemModel(profile: .address)])

        infoProfile <~ SignalProducer.combineLatest(fullName.producer,
                                                    phoneNumber.producer,
                                                    address.producer,
                                                    cityId.producer)
        userAsset <~ SignalProducer.combineLatest(fullName.producer,
                                                  phoneNumber.producer,
                                                  address.producer,
                                                  city.producer)
        
        isLoading = Signal.merge(fetchProfileAction.isExecuting.signal,
                                 saveAction.isExecuting.signal)
        errors = Signal.merge(fetchProfileAction.errors.map { $0 },
                              saveAction.errors.map { $0 },
                              validateInputProfileAction.errors.map { $0 })
        reloadData = profile.signal.map { _ in }
    }
    
    func fetchProfile() {
        fetchProfileAction.apply().start()
    }
    
    func nativeToBackView() {
        router.backView()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {}
    
    private func content(at indexPath: IndexPath) -> ProfileItemModel {
        profile.value[indexPath.row]
    }
    
    let cellMapping: [String: UITableViewCell.Type] = ["profile_cell": ProfileCell.self]
    
    let style: UITableView.Style = .plain
    
    func numberOfRows(in section: Int) -> Int {
        profile.value.count
    }
    
    func numberOfSections() -> Int { 1 }
    
    func cellIdentifier(at indexPath: IndexPath) -> String {
        "profile_cell"
    }
    
    func configure<T>(cell: T, at indexPath: IndexPath) where T: UITableViewCell {
        guard let profileCell = cell as? ProfileCell else { fatalError() }
        let model = content(at: indexPath)
        profileCell.configure(model: model)
        switch model.profile {
        case.fullName:
            profileCell.textField.reactive.text <~ fullName
            fullName <~ profileCell.textField.reactive.continuousTextValues
                .take(until: profileCell.reactive.prepareForReuse)
        case .phoneNumber:
            profileCell.textField.reactive.text <~ phoneNumber
            profileCell.textField.keyboardType = .numberPad
            phoneNumber <~ profileCell.textField.reactive.continuousTextValues
                .take(until: profileCell.reactive.prepareForReuse)
        case .address:
            profileCell.textField.reactive.text <~ address
            address <~ profileCell.textField.reactive.continuousTextValues
                .take(until: profileCell.reactive.prepareForReuse)
        }
    }
    
    func willDisplayCell(_ cell: UITableViewCell, at indexPath: IndexPath) {}
    
    func didEndDisplayingCell(_ cell: UITableViewCell, at indexPath: IndexPath) {}
}
