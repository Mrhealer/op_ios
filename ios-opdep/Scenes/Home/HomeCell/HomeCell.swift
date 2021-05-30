//
//  File.swift
//  ios-opdep
//
//  Created by Quang Nguyễn Như on 01/05/2021.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class HomeCell: UITableViewCell {
    
    let container = UIView()
    let background = UIImageView()
    let name = StyleLabel(font: .font(style: .bold, size: 24),
                          textColor: .white)
    
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
        backgroundColor = .clear
        container.withBorder(width: 1, cornerRadius: 16)
        container.backgroundColor = .white
        container.whiteShadow()
        background.layer.cornerRadius = 16
        background.clipsToBounds = true
        background.contentMode = .scaleAspectFill
        
        addSubviews(container)
        container.addSubviews(background, name)
        container.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-8)
        }
        name.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-8)
        }
        background.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        background.image = nil
        name.text = nil
    }
    
    func configure(viewModel: Categories) {
        if let urlString = viewModel.imageUrl, let url = URL(string: urlString) {
            background.af.setImage(withURL: url)
        }
        name.text = viewModel.name
    }
}
