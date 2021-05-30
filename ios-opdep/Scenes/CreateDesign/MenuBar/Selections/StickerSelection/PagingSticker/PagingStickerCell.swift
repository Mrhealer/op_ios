//
//  PagingStickerCell.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/21/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import SnapKit
import AlamofireImage
import ReactiveSwift

class PagingStickerCell: UICollectionViewCell {
    let designGridView: GridView<DesignGridViewModel>
    override init(frame: CGRect) {
        designGridView = .init(viewModel: .init(backgroundColor: .white,
                                                scrollDirection: .vertical,
                                                itemsPerUnit: 5,
                                                padding: 10,
                                                itemSpacing: 20))
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func prepare() {
        contentView.addSubview(designGridView)
        designGridView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(viewModel: CategoryBarItemViewModel) {
        designGridView.viewModel.designs <~ viewModel.model.producer
            .take(until: reactive.prepareForReuse)
            .map { $0.images }
    }
}
