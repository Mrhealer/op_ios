//
//  GenericRouter.swift

import UIKit

protocol Router: class {
    var navigationController: UINavigationController? { get }
    func start()
    func present(router: Router, animated: Bool, completion: (() -> Void)?)
    func present(viewController: UIViewController?, animated: Bool, completion: (() -> Void)?)
    func navigate(to viewController: UIViewController, animated: Bool)
}

extension Router {
    func present(router: Router, animated: Bool, completion: (() -> Void)?) {
        present(viewController: router.navigationController,
                animated: animated,
                completion: completion)
    }
    
    func present(viewController: UIViewController?,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        navigationController?.present(viewController,
                                      animated: animated,
                                      completion: completion)
    }
    
    func navigate(to viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
}

// MARK: Generic Router
class GenericRouter<Container: UINavigationController>: Router {
    var navigationController: UINavigationController? { container }
    
    weak var container: Container?
    init(_ container: Container?) {
        self.container = container
        prepare()
    }
    
    deinit { print("deinit") }
    
    func prepare() {}
    
    func start() { print("start") }
}
