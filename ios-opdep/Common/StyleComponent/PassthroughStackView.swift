//
//  PassthroughStackView.swift

import UIKit

class PassthroughStackView: UIStackView {
    var canPassthrough = true
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard canPassthrough else { return super.hitTest(point, with: event) }
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
