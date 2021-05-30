//
//  InformationCell.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 5/28/21.
//

import UIKit

class InformationCell: UITableViewCell {

    @IBOutlet weak var img_left: UIImageView!
    @IBOutlet weak var txt_title: UILabel!
    @IBOutlet weak var img_right: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
