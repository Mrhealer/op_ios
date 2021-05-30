//
//  IconButton.swift

import UIKit
import ReactiveCocoa
import ReactiveSwift

class IconButton: UIButton {
    let iconView = UIImageView()
    let textLabel = StyleLabel()
    private let contentView = PassthroughStackView()
    
    init(axis: NSLayoutConstraint.Axis = .vertical,
         icon: UIImage? = nil,
         title: String? = nil,
         textAlightment: NSTextAlignment = .center,
         tintColor: UIColor? = nil,
         stackAlighment: UIStackView.Alignment = .center,
         spacing: CGFloat = 0,
         contentInsets: UIEdgeInsets = .zero) {
        super.init(frame: .zero)
        iconView.image = icon
        textLabel.text = title
        prepare(axis: axis,
                spacing: spacing,
                textAlightment: textAlightment,
                stackAlighment: stackAlighment,
                contentInsets: contentInsets)
        if let tintColor = tintColor {
            textLabel.textColor = tintColor
            iconView.tintColor = tintColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare(axis: NSLayoutConstraint.Axis,
                         spacing: CGFloat,
                         textAlightment: NSTextAlignment,
                         stackAlighment: UIStackView.Alignment,
                         contentInsets: UIEdgeInsets = .zero) {
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        iconView.contentMode = .scaleAspectFit
        iconView.clipsToBounds = true
        textLabel.textAlignment = textAlightment
        textLabel.font = .primary(size: 12)
        let spec = StackSpec(axis: axis,
                             alignment: stackAlighment,
                             spacing: spacing)
        
        spec.add(iconView, textLabel)
        contentView.load(spec: spec)
        textLabel.setContentCompressionResistancePriority(.required, for: axis)
        iconView.setContentCompressionResistancePriority(.required, for: axis)
        iconView.setContentHuggingPriority(.required, for: axis)
        setContentCompressionResistancePriority(.required, for: axis)
        iconView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        textLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(20)
        }
        setTitleColor(.clear, for: .normal)
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        setTitle(title)
    }
    
    override var tintColor: UIColor! {
        didSet {
            iconView.tintColor = tintColor
            textLabel.textColor = tintColor
        }
    }
    
    func setTitle(_ title: String?) {
        textLabel.text = title ?? ""
    }
    
    func setTitleColor(_ color: UIColor?) {
        textLabel.textColor = color
    }
    
    func setTitleFont(_ font: UIFont) {
        textLabel.font = font
    }
    
    func setIcon(_ image: UIImage?) {
        iconView.image = image
    }
    
    func layoutAlignmentLeft() {
        iconView.setContentHuggingPriority(.required, for: .horizontal)
    }
}
