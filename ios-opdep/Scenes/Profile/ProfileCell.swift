//
//  ProfileCell.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 16/05/2021.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class ProfileCell: UITableViewCell {
    let textField = SkyFloatingLabelTextField.create()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        backgroundColor = .white
        let container = UIView()
        contentView.addSubview(container)
        container.addSubviews(textField)
        container.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
    }
        
    func configure(model: ProfileItemModel) {
        textField.placeholder = model.profile.title
    }
}
