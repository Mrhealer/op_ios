//
//  Localizable.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 27/04/2021.
//

import Foundation
import Localize

protocol Localizable {
    var localized: String { get }
}
extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

public func localized(str: String) -> String {
    return NSLocalizedString(str, comment: str)
}

struct Localize {
    enum Common {
        static let confirm: String     = localized(str: "button_confirm")
    }
    enum Login {
        static let title: String       = localized(str: "title_login")
        static let description: String = localized(str: "description_login")
        static let numberPhone: String = localized(str: "placeholder_phone")
        static let otp: String         = localized(str: "placeholder_otp")
        static let submit: String      = localized(str: "button_submit")
    }
    enum Editor {
        static let editorImage: String             = localized(str: "editor_image")
        static let editorColor: String             = localized(str: "editor_color")
        static let editorText: String              = localized(str: "editor_text")
        static let editorSticker: String           = localized(str: "editor_sticker")
        
        static let title: String                   = localized(str: "your_design")
        static let editorBackground: String        = localized(str: "editor_background")
        static let editorFrame: String             = localized(str: "editor_frame")
        static let editorEffects: String           = localized(str: "editor_effects")
        static let editorReset: String             = localized(str: "editor_reset")
        static let editorYourPhoto: String         = localized(str: "editor_your_photo")
        static let editorFromCamera: String        = localized(str: "editor_from_camera")
        static let editorFromPhotoLibrary: String  = localized(str: "editor_from_photo_library")
        static let editorPattern: String           = localized(str: "editor_pattern")
        static let editorTextures: String          = localized(str: "editor_textures")
        static let editorColours: String           = localized(str: "editor_colours")
        static let editorInsertImage: String       = localized(str: "editor_Insert_Image")
        static let editorNoImage: String           = localized(str: "editor_no_image")
        static let editorNoText: String            = localized(str: "editor_no_text")
        static let attributeText: String           = localized(str: "editor_attribute_text")
        static let attributeImage: String          = localized(str: "editor_attribute_image")
        static let attributecolor: String          = localized(str: "editor_attribute_color")
    }
    enum ShoppingCart {
        static let title: String       = localized(str: "cart_title")
        static let next: String        = localized(str: "cart_next")
        static let delete: String      = localized(str: "cart_delete")
        static let quantity: String    = localized(str: "cart_quantity")
        static let shipping: String    = localized(str: "cart_shipping_price")
        static let total: String       = localized(str: "cart_total_price")
        static let empty: String       = localized(str: "cart_empty")
    }
    enum UploadDesign {
        static let title: String       = localized(str: "upload_design_title")
        static let next: String        = localized(str: "upload_design_next")
        static let delete: String      = localized(str: "cart_delete")
        static let quantity: String    = localized(str: "cart_quantity")
        static let shipping: String    = localized(str: "cart_shipping_price")
        static let total: String       = localized(str: "cart_total_price")
        static let empty: String       = localized(str: "cart_empty")
    }
    enum InfomationAccount {
        static let titleInfor: String    = localized(str: "information_common")
        static let titleSettings: String = localized(str: "information_settings")
        static let cardOrder: String     = localized(str: "cart_title")
        static let receivedOrder: String = localized(str: "information_received_order")
        static let historyOrder: String  = localized(str: "information_history_order")
        static let instagram: String     = localized(str: "information_instagram")
        static let facebook: String      = localized(str: "information_facebook")
        static let share: String         = localized(str: "information_share")
        static let term: String          = localized(str: "information_term")
        static let survey: String        = localized(str: "information_survey")
        static let auth: String          = localized(str: "information_auth")

    }

}
