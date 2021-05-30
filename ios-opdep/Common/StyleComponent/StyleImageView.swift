//
//  StyleImageView.swift
import UIKit

class StyleImageView: UIImageView {
    var rounded: Bool = false {
        didSet {
            layer.masksToBounds = rounded
        }
    }
    init(image: UIImage? = nil,
         tintColor: UIColor? = .clear,
         contentMode: UIView.ContentMode = .scaleAspectFit,
         renderingMode: UIImage.RenderingMode = .alwaysTemplate) {
        super.init(frame: .zero)
        self.image = image?.withRenderingMode(renderingMode)
        self.tintColor = tintColor
        self.contentMode = contentMode
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard rounded else { return }
        layer.cornerRadius = bounds.height / 2
    }
}
