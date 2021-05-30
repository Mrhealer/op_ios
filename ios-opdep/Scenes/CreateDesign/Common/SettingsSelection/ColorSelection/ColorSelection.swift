//
//  ColorSelection.swift
//  OPOS
//
//  Created by Tran Van Dinh on 8/24/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class ColorSelection: GridView<ColorSelectionViewModel> {
    override func prepare() {
        super.prepare()
        reactive.isHidden <~ viewModel.isSelected.negate()
    }
}
