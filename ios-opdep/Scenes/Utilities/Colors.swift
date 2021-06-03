//
//  Colors.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 6/3/21.
//

import Foundation
import UIKit

struct Colors {
    var objectsArray = [
        TableViewCellModel(
            category: "Category #1",
            subcategory: ["SubCategory #1.1", "SubCategory #1.2"],
            colors: [
                // SubCategory #1.1
                [CollectionViewCellModel(color: .blue, name: "Orchid"),
                 CollectionViewCellModel(color: .red, name: "Salmon"),
                 CollectionViewCellModel(color: .brown, name: "Old Lace"),
                 CollectionViewCellModel(color: .blue, name: "Aqua"),
                 CollectionViewCellModel(color: .black, name: "Sea Green")],
                // SubCategory #1.2
                [CollectionViewCellModel(color: .blue, name: "Dark Slate Gray"),
                 CollectionViewCellModel(color: .brown, name: "Honeydew"),
                 CollectionViewCellModel(color: .purple, name: "Gainsboro")]
            ]),
        TableViewCellModel(
            category: "Category #2",
            subcategory: ["SubCategory #2.1"],
            colors: [
                // SubCategory #2.1
                [CollectionViewCellModel(color: .purple, name: "Moccasin"),
                 CollectionViewCellModel(color: .brown, name: "Pale Turquoise"),
                 CollectionViewCellModel(color: .blue, name: "Dark Violet"),
                 CollectionViewCellModel(color: .red, name: "Medium Sea Green")]
            ]),
        TableViewCellModel(
            category: "Category #3",
            subcategory: ["SubCategory #3.1", "SubCategory #3.2"],
            colors: [
                // SubCategory #3.1
                [CollectionViewCellModel(color: .red, name: "Tomato"),
                 CollectionViewCellModel(color: .red, name: "Steel Blue"),
                 CollectionViewCellModel(color: .red, name: "Light Slate Gray"),
                 CollectionViewCellModel(color: .red, name: "Midnight Blue"),
                 CollectionViewCellModel(color: .red, name: "Brown")],
                // SubCategory #3.2
                [CollectionViewCellModel(color: .red, name: "Cornsilk"),
                 CollectionViewCellModel(color: .red, name: "Magenta"),
                 CollectionViewCellModel(color: .red, name: "Lawn Green"),
                 CollectionViewCellModel(color: .red, name: "Black"),
                 CollectionViewCellModel(color: .red, name: "Deep Sky Blue"),
                 CollectionViewCellModel(color: .red, name: "Cornflower Blue"),
                 CollectionViewCellModel(color: .red, name: "Dark Orange"),
                 CollectionViewCellModel(color: .red, name: "Light Sea Green"),
                 CollectionViewCellModel(color: .red, name: "Pink")]
            ]),
        TableViewCellModel(
            category: "Category #4",
            subcategory: ["SubCategory #4.1", "SubCategory #4.2"],
            colors: [
                // SubCategory #4.1
                [CollectionViewCellModel(color: .blue, name: "Plum"),
                 CollectionViewCellModel(color: .blue, name: "Seashell"),
                 CollectionViewCellModel(color: .blue, name: "Navajo White"),
                 CollectionViewCellModel(color: .blue, name: "Lime"),
                 CollectionViewCellModel(color: .blue, name: "Khaki")],
                // SubCategory #4.2
                [CollectionViewCellModel(color: .blue, name: "Antique White"),
                 CollectionViewCellModel(color: .blue, name: "Medium Violet Red"),
                 CollectionViewCellModel(color: .blue, name: "Olive Drab"),
                 CollectionViewCellModel(color: .blue, name: "Orange Red"),
                 CollectionViewCellModel(color: .blue, name: "Lavender Blush")]
            ]),
        TableViewCellModel(
            category: "Category #5",
            subcategory: ["SubCategory #5.1", "SubCategory #5.2"],
            colors: [
                // SubCategory #5.1
                [CollectionViewCellModel(color: .blue, name: "Amethyst")],
                // SubCategory #5.2
                [CollectionViewCellModel(color: .blue, name: "Medium Slate Blue"),
                 CollectionViewCellModel(color: .blue, name: "Maroon"),
                 CollectionViewCellModel(color: .blue, name: "Light Salmon"),
                 CollectionViewCellModel(color: .blue, name: "Lavender"),
                 CollectionViewCellModel(color: .blue, name: "Bisque")]
            ])
    ]
}
