//
//  MenuBarViewModel.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/9/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

enum MenuBarType {
    case none
    case background
    case frame
    case styleFrame
    case text
    case sticker
    case color
    case photo
    
    var title: String {
        switch self {
        case .background: return Localize.Editor.editorBackground
        case .frame: return Localize.Editor.editorBackground
        case .styleFrame: return Localize.Editor.editorFrame
        case .text: return Localize.Editor.editorText
        case .sticker: return Localize.Editor.editorSticker
        case .color: return Localize.Editor.editorColor
        case .photo: return Localize.Editor.editorImage
        case .none: return ""
        }
    }
    
    var image: UIImage? {
        switch self {
        case .background: return R.image.menu_bar_new_photo()
        case .frame: return nil
        case .styleFrame: return nil
        case .text: return R.image.menu_bar_new_text()
        case .sticker: return R.image.menu_bar_new_sticker()
        case .none: return nil
        case .color: return R.image.text_color()
        case .photo: return R.image.menu_bar_new_photo()
        }
    }
}

class MenuBarItemModel: Equatable {
    let type: MenuBarType
    let image = MutableProperty<UIImage?>(nil)
    let isSelected = MutableProperty<Bool>(false)
    let identifier = UUID().uuidString
    init(type: MenuBarType) {
        self.type = type
        image <~ isSelected.map { _ in type.image }
    }
    static func == (lhs: MenuBarItemModel, rhs: MenuBarItemModel) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

class MenuBarViewModel {
    let menus = MutableProperty<[MenuBarItemModel]>([])
    let selectedItem = MutableProperty<MenuBarItemModel?>(nil)
    let selectItemAction: Action<MenuBarItemModel, MenuBarItemModel, Never>
    init() {
        selectItemAction = Action { .init(value: $0) }
        selectedItem <~ selectItemAction.values
    }
}
