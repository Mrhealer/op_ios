//
//  BasicViewModel.swift

import Foundation
import ReactiveSwift

protocol ProgressViewModel {
    var isLoading: Signal<Bool, Never> { get }
}

protocol ThrowableViewModel {
    associatedtype OutputError: Error
    var errors: Signal<OutputError, Never> { get }
}

typealias BasicViewModel = ProgressViewModel & ThrowableViewModel

// MARK: - ViewController and ViewModel binding
extension UIViewController {
    /// Bind view model loading and error state with view controller
    func bindViewModel<T: BasicViewModel>(_ viewModel: T) {
        bindProgressState(with: viewModel)
        bindErrorState(with: viewModel)
    }
    
    /// Bind view model loading state with view controller
    func bindProgressState(with viewModel: ProgressViewModel) {
        viewModel.isLoading.observe(on: UIScheduler())
            .skipRepeats()
            .observeValues { [weak self] isLoading in
                self?.view.endEditing(true)
                isLoading ? self?.showProgressIndicator() : self?.hideProgressIndicator()
        }
    }
    
    func bindErrorState<T: ThrowableViewModel>(with viewModel: T) {
        viewModel.errors.observe(on: UIScheduler())
            .observeValues { [weak self] error in
                self?.displayError(error)
        }
    }
    
    func displayError(_ error: Error) {
        presentSimpleAlert(title: "Thông Báo",
                           message: error.localizedDescription)
    }
}

// MARK: -
protocol ViewModelController {
    associatedtype ViewModel
    var viewModel: ViewModel { get }
    init(viewModel: ViewModel)
}
