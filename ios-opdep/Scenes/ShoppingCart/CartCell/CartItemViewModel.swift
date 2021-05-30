//
//  CartItemViewModel.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 11/05/2021.
//

import Foundation
import ReactiveSwift

class CartItemViewModel {
    let model: ShoppingCart
    
    let imageProduct: MutableProperty<URL?>
    let productName: MutableProperty<String>
    let quantity: MutableProperty<String>
    
    let deleteAction: Action<Void, ShoppingCart, Never>
    
    init(model: ShoppingCart,
         apiService: APIService) {
        self.model = model
        imageProduct = MutableProperty(model.imageProduct)
        productName = MutableProperty(model.name.asStringOrEmpty())
        quantity = MutableProperty(model.valueQuantity)
        
        deleteAction = Action { [model] in
            .init(value: model)
        }
    }
    
    func unitFromModel(model: ShoppingCart) -> NSMutableAttributedString {
        let priceDiscount = UtilityPrice
            .formatCurrency(currencyString: model.priceDiscount.asStringOrEmpty())
        let price = UtilityPrice.formatCurrency(currencyString: model.price)
        let text = "Giá: \(price) \(priceDiscount)"
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.font(style: .regular, size: 16)
        ]
        let attributePrice = NSMutableAttributedString(string: text,
                                                       attributes: attributes)
        attributePrice.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                    value: 1,
                                    range: NSRange(location: 5,
                                                   length: price.count))
        return attributePrice
    }
}
