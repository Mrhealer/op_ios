//
//  LayoutSpecItem.swift

import UIKit

protocol LayoutSpecBuildable: class {
    func build() -> UIView
}

protocol LayoutSpecLoadable: class {
    associatedtype Spec: LayoutSpecBuildable
    func load(spec: Spec)
    func reload(with spec: Spec)
}

// MARK: -
extension UIView: LayoutSpecBuildable {
    func build() -> UIView { self }
}
