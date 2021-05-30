//
//  PagingStickerView.swift
//  OPOS
//
//  Created by Tran Van Dinh on 7/21/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class PagingStickerView: GridView<PagingStickerViewModel> {
    override func prepare() {
        super.prepare()
        viewModel.scrollToItem.signal
            .skipNil()
            .observeValues { [collectionView] in
                collectionView.scrollToItem(at: $0,
                                            at: .centeredHorizontally,
                                            animated: true)
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = collectionView.indexPathsForVisibleItems.first
        viewModel.currentIndexPath.swap(indexPath)
    }
}
