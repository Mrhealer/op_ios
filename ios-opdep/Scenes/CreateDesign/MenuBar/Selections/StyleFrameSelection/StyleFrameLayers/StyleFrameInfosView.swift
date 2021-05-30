//
//  StyleFrameInfosView.swift
//  OPOS
//
//  Created by Tran Van Dinh on 10/6/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class StyleFrameInfosView: UIView {
    let viewModel: StyleFrameInfosViewModel
    let infosView: GridView<StyleFrameInfosViewModel>
    let annotation = UIImageView(image: R.image.down_arrow())
    let container = UIView()
    
    init(viewModel: StyleFrameInfosViewModel) {
        self.viewModel = viewModel
        infosView = .init(viewModel: viewModel)
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        isHidden = true
        let dismissButton = UIButton()
        addSubviews(dismissButton, container, annotation)
        container.addSubviews(infosView)
        [infosView, dismissButton].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        annotation.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 26,
                                   height: 16))
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-viewModel.spaceFromBottom + 16)
        }
        container.backgroundColor = .clear
        infosView.backgroundColor = .clear
        container.dropShadow(color: .init(hexString: "000000", alpha: 0.3),
                             offSet: CGSize(width: 0.0, height: 0.0),
                             radius: 8)
        
        reactive.isHidden <~ SignalProducer.merge(dismissButton.reactive.controlEvents(.touchUpInside).map { _ in true },
                                                  viewModel.frameInfos.signal.filter { $0.count == 0 }.map { _ in true },
                                                  viewModel.selectedFrame.signal.skipNil().map { _ in true })
        
        viewModel.frameInfos.signal.observeValues { [weak self] in
            guard let sself = self else { return }
            // compute height
            var height: CGFloat = CGFloat(40 * $0.count)
            // 50 : navigationbar's height and 40: padding
            let maxHeight = sself.bounds.height - sself.viewModel.spaceFromBottom - 50 - 40
            
            if height > maxHeight {
                height = maxHeight
            }
            var safeAreaBottomHeight: CGFloat = 0
            if #available(iOS 11.0, *) {
                safeAreaBottomHeight = sself.safeAreaInsets.bottom
            }
            let frame = CGRect(origin: .zero,
                               size: .init(width: 100,
                                           height: height))
            sself.container.frame = frame
            sself.container.center = CGPoint(x: UIScreen.main.bounds.width - 8 - 50,
                                             y: sself.bounds.height - sself.viewModel.spaceFromBottom - frame.height / 2 - safeAreaBottomHeight)
            sself.infosView.collectionView.reloadData()
        }
    }
}
