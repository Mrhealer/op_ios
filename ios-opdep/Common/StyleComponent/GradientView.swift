//
//  GradientView.swift

import UIKit

class GradientView: UIView {
    enum Direction {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
        case topLeftToBottomRight
        var startPoint: CGPoint {
            switch self {
            case .leftToRight:
                return CGPoint(x: 0, y: 0.5)
            case .rightToLeft:
                return CGPoint(x: 1, y: 0.5)
            case .topToBottom:
                return CGPoint(x: 0.5, y: 0)
            case .bottomToTop:
                return CGPoint(x: 0.5, y: 1)
            case .topLeftToBottomRight:
                return CGPoint(x: 0.4, y: 0)
            }
        }
        var endPoint: CGPoint {
            switch self {
            case .leftToRight:
                return CGPoint(x: 1, y: 0.5)
            case .rightToLeft:
                return CGPoint(x: 0, y: 0.5)
            case .topToBottom:
                return CGPoint(x: 0.5, y: 1)
            case .bottomToTop:
                return CGPoint(x: 0.5, y: 0)
            case .topLeftToBottomRight:
                return CGPoint(x: 0.6, y: 1)
            }
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    var locations: [NSNumber]? {
        get { gradientLayer.locations }
        set { gradientLayer.locations = newValue }
    }
    let direction: Direction
    let colors: [UIColor]
    init(direction: Direction,
         colors: [UIColor],
         locations: [NSNumber]? = nil) {
        self.direction = direction
        self.colors = colors
        super.init(frame: .zero)
        gradientLayer.locations = locations
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        gradientLayer.startPoint = direction.startPoint
        gradientLayer.endPoint = direction.endPoint
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.shouldRasterize = true
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

extension GradientView {
    static func makeDefault(direction: GradientView.Direction = .bottomToTop) -> GradientView {
        GradientView(direction: direction,
                     colors: [.black,
                              UIColor.black.withAlphaComponent(0.3),
                              .clear],
                     locations: [
                        NSNumber(0),
                        NSNumber(0.8),
                        NSNumber(1)])
    }
}
