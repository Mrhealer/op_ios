//
//  AttributeFont.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/5/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class AttributeFont: GridView<AttributeFontViewModel> {
    override func prepare() {
        super.prepare()
        reactive.isHidden <~ viewModel.isSelected.negate()
    }
}
