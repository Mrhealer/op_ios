//
//  BackgroundLayer.swift
//  OPOS
//
//  Created by Tran Van Dinh on 9/2/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class AddImagePlaceHolder: UIView {
    let addButton = StyleButton()
    init() {
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// Việc sử dụng ImageTransformable(BaseView) vẫn còn 1 số hạn chế nếu không sử dụng clipToBounds khi zoom hoặc việc move khi ra khỏi visible màn hình( không thể cho quay trở lại). Giải pháp:
//    - Có thể cải tiến tiếp: giống như StoryChic là ngăn ko cho ra khỏi khung design, zoom tính toán ở vị trí anchor nơi có touch thay vì mặc định center.
//    - Hoặc dùng lại DesignSingleImage
class BackgroundLayer: UIView {
    let originSize = UIScreen.main.bounds.size
    let background: ImageTransformable
    let imagePlaceHolder = AddImagePlaceHolder()
    
    let viewModel: BackgroundLayerViewModel
    init(viewModel: BackgroundLayerViewModel, frame: CGRect) {
        self.viewModel = viewModel
        background = ImageTransformable(url: nil,
                                        designSize: originSize,
                                        contentMode: .scaleAspectFill)
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        addSubviews(background, imagePlaceHolder)
        background.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                                    y: UIScreen.main.bounds.height / 2)
        imagePlaceHolder.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        background.setEnableZoom(false)
        background.setEnableClose(false)
        background.setEnableRotate(false)
        background.setEnableScaleTop(false)
        background.setEnableScaleLeft(false)
        background.setEnableScaleRight(false)
        background.outlineBorderColor = .clear
        
        Signal.merge(viewModel.changedSaturationAction.values,
                     viewModel.changedBrightnessAction.values,
                     viewModel.changedContrastAction.values,
                     viewModel.selectFilterTemplateAction.values,
                     viewModel.currentImage.signal)
            .observeValues { [weak self] in
                self?.setImage($0)
        }
        reactive.reset <~ viewModel.reset
        reactive.rotate <~ viewModel.rotate
        reactive.flip <~ viewModel.flip
    }
    
    // ở đây khi set image cho UIImageView cần set lại frame nếu không thì khi move hoặc actions khác nó sẽ không nhận vì nó chỉ nhận trong khoảng frame của nó. Do mình sử dụng contentMode = scaleAspectFill và không clipToBounds. Để an toàn cho BaseView thì dùng clipToBounds nhưng ko thể scroll hết image
    func setImage(_ image: UIImage?) {
        guard let image = image else { return }
        background.transform = .identity
        imagePlaceHolder.isHidden = true
        background.imageView.image = image
        let size = CGSize.aspectFill(aspectRatio: image.size,
                                     minimumSize: originSize)
        background.frame = CGRect(origin: .zero,
                                  size: size)
        background.center = CGPoint(x: frame.width / 2,
                                    y: frame.height / 2)
    }
    
    func reset() {
        imagePlaceHolder.isHidden = false
        background.imageView.image = nil
        viewModel.currentImage.swap(nil)
    }
    
    func flip() {
        guard background.imageView.image != nil else { return }
        background.transform = background.transform.scaledBy(x: -1,
                                                             y: 1)
    }
    
    func rotate() {
        guard let image = background.imageView.image else { return }
        let rotatedImage = image.rotate(radians: .pi / 2)
        if let currentImage = viewModel.currentImage.value {
            let rotatedCurrentImage = currentImage.rotate(radians: .pi / 2)
            viewModel.currentImage.swap(rotatedCurrentImage)
        }
        setImage(rotatedImage)
    }
}

extension Reactive where Base: BackgroundLayer {
    var reset: BindingTarget<Void> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.reset()
        }
    }
    
    var flip: BindingTarget<Void> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.flip()
        }
    }
    
    var rotate: BindingTarget<Void> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.rotate()
        }
    }
}
