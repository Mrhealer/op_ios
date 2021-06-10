//
//  CollectionViewCell.swift
//  CollectionViewInsideTableViewExample
//
//  Created by John Codeos on 12/21/19.
//  Copyright © 2019 John Codeos. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var colorView: UIView!

    @IBOutlet weak var imageTemplate: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.layer.cornerRadius = 5
        colorView.layer.masksToBounds = true
    }
}
