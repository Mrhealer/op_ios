//
//  UIImageView.swift

import Foundation
import ReactiveSwift
import AlamofireImage

extension Reactive where Base: UIImageView {
    var imageFromUrl: BindingTarget<URL?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let url = value else { return }
            base.af.setImage(withURL: url)
        }
    }
}
