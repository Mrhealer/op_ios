//
//  PhoneTableViewCell.swift
//  ios-opdep
//
//  Created by VMO on 6/10/21.
//

import UIKit

class PhoneTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 5
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
    }
    
}
