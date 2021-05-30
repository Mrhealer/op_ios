//
//  UIButton.swift

import UIKit

extension UIButton {
    
    func setBackgroundColor(_ color: UIColor?, forState: UIControl.State) {
        guard let color = color else {
            setBackgroundImage(nil, for: forState)
            return
        }
        setBackgroundImage(UIImage.imageWithColor(color), for: forState)
    }
}

import ReactiveCocoa
import ReactiveSwift
extension UIButton {
    func hidesWhenDisabled() {
        reactive.producer(forKeyPath: #keyPath(UIButton.isEnabled))
            .observe(on: UIScheduler())
            .take(during: reactive.lifetime)
            .startWithValues { [weak self] isEnabled in
                guard let isEnabled = isEnabled as? Bool else { return }
                self?.isHidden = !isEnabled
        }
    }
}

extension Reactive where Base: UIButton {
    func backgroundColor(forState state: UIButton.State) -> BindingTarget<UIColor?> {
        makeBindingTarget(on: UIScheduler()) { [state] base, value in
            base.setBackgroundColor(value, forState: state)
        }
    }
}
