//
//  TemplateCollectionCell.swift
//  ios-opdep
//
//  Created by VMO on 6/9/21.
//

import UIKit

class TemplateCollectionCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var templateImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowColor = #colorLiteral(red: 0.4470588235, green: 0.4862745098, blue: 0.5647058824, alpha: 0.5087587248)
        containerView.layer.shadowOpacity = 1
    }

}
