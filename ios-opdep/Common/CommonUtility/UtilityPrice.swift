//
//  UtilityPrice.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 12/05/2021.
//

import Foundation
import UIKit

class UtilityPrice: NSObject {
    // MARK: Chuyển price về dạng xx.xxx
    static func formatCurrency(currencyString: String) -> String {
        if let value = Double(currencyString) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            formatter.maximumFractionDigits = 0
            if let result = formatter.string(from: value as NSNumber) {
                return result + " đ"
            }
        }
        return ""
    }
    // MARK: thêm gạch giữa vào text
    static func formatPriceOriginal(price: String,
                                    textColor: UIColor,
                                    fontName: UIFont) -> NSMutableAttributedString {
        let attributes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: fontName
        ]
        let attributePrice = NSMutableAttributedString(string: price,
                                                       attributes: attributes)
        // Format strike
        attributePrice.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                    value: 1,
                                    range: NSRange(location: 0,
                                                   length: attributePrice.string.count))
        
        return attributePrice
    }
    
    // MARK: Tính tổng tiền trong shopping cart
    static func mathTotalPrice(data: [CartItemViewModel]) -> String {
        var totalPrice = 0
        data.forEach { element in
            let quantity = Int(element.model.quantity) ?? 0
            var price = Int(element.model.price) ?? 0
            if let priceDiscount = element.model.priceDiscount {
                price = Int(priceDiscount) ?? 0
            }
            totalPrice += (quantity * price)
        }
        return UtilityPrice.formatCurrency(currencyString: totalPrice.toString())
    }
}
