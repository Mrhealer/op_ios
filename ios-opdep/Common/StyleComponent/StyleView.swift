//
//  StyleView.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 23/05/2021.
//

import Foundation
import UIKit

class StyleView: UIView {

    required init(backgroundColor: UIColor? = UIColor.white,
                  cornerRadius: CGFloat = 0,
                  borderColor: CGColor? = nil,
                  borderWidth: CGFloat = 0.0) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
