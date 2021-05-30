//
//  StickerLayerViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 10/22/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class StickerLayerViewModel {
    let pickedImage = MutableProperty<UIImage?>(nil)
    let selectedNewSticker = MutableProperty<Bool>(false)
    let deselect = MutableProperty<Void>(())
    let imageUrl = MutableProperty<URL?>(nil)
}
