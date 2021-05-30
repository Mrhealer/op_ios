//
//  DesignScrolledImage.swift
//  OPOS
//
//  Created by Tran Van Dinh on 6/1/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import UIKit
import ReactiveSwift
import GPUImage

class DesignScrolledImage: UIView {
    var originalImage: UIImage?
    let id: String = UUID().uuidString
    
    private let border = CAShapeLayer()
    private var borderColor: UIColor = .init(hexString: "#717171")
    private let cornerRadius: CGFloat = 2
    // for scrolling both : hoz + ver
    private let imagePadding: CGFloat = 2
    private let extraSpace: CGFloat
        
    let designedImageView = StyleImageView()
    private let scrollView = UIScrollView()
    let addButton = StyleButton(image: R.image.add_photo(),
                                backgroundColor: .init(hexString: "#E5E5E5"))
    let tapRecognizer = UITapGestureRecognizer()
    let longPressRecognizer = UILongPressGestureRecognizer()
    
    init(frame: CGRect, extraSpace: CGFloat = 0) {
        self.extraSpace = extraSpace
        super.init(frame: frame)
        prepare()
    }
    
    override init(frame: CGRect) {
        extraSpace = 0
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Prepare
    private func prepare() {
        addSubviews(scrollView, addButton)
        scrollView.clipsToBounds = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        clipsToBounds = true
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
        scrollView.addSubview(designedImageView)
        scrollView.delegate = self
        [addButton, scrollView].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        let rotationRecognizer = UIRotationGestureRecognizer(target: self,
                                                             action: #selector(handleRotation(_:)))
        addGestureRecognizer(rotationRecognizer)
        rotationRecognizer.delegate = self
        
        addGestureRecognizer(tapRecognizer)
        addGestureRecognizer(longPressRecognizer)
        drawBorder(isHidden: false)
    }
    
    func lockActions() {
        scrollView.isUserInteractionEnabled = false
    }
    
    func unlockActions() {
        scrollView.isUserInteractionEnabled = true
    }
    
    // MARK: - Handle Gesture
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        scrollView.transform = scrollView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
        
    func addImage(_ image: UIImage?) {
        designedImageView.transform = .identity
        designedImageView.image = image
        guard let image = image else {
            showAddButton()
            return
        }
        layoutWithImage(image: image)
        hideAddButton()
    }
    
    private func layoutWithImage(image: UIImage) {
        let size = sizeForImage(image)
        designedImageView.frame = CGRect(origin: .zero,
                                         size: size)
        scrollView.contentSize = size
        scrollView.setContentOffset(CGPoint(x: size.width/2 - frame.size.width/2,
                                            y: size.height/2 - frame.size.height/2),
                                    animated: false)
    }
    
    func hideAddButton() {
        drawBorder(isHidden: true)
        addButton.isHidden = true
    }
    
    func showAddButton() {
        drawBorder(isHidden: false)
        addButton.isHidden = false
    }
    
    private func sizeForImage(_ image: UIImage) -> CGSize {
        let widthScale = frame.size.width / image.size.width
        let heightScale = frame.size.height / image.size.height
        if heightScale > widthScale {
            return CGSize(width: frame.size.height * image.size.width / image.size.height + imagePadding,
                          height: frame.size.height + imagePadding)
        } else {
            return CGSize(width: frame.size.width + imagePadding,
                          height: frame.size.width * image.size.height / image.size.width + imagePadding)
        }
    }
    
    func drawBorder(isHidden: Bool = true,
                    color: UIColor = .init(hexString: "#717171")) {
        borderColor = color
        if !isHidden {
            border.strokeColor = borderColor.cgColor
            border.fillColor = nil
            border.lineDashPattern = [4, 2]
            border.lineWidth = 1.0
            border.frame = bounds
            let bezierPath = UIBezierPath(roundedRect: bounds.insetBy(dx: extraSpace / 2,
                                                                      dy: extraSpace / 2),
                                          cornerRadius: cornerRadius)
            bezierPath.lineJoinStyle = CGLineJoin.round
            border.path =  bezierPath.cgPath
            if border.superlayer == nil {
                layer.addSublayer(border)
            }
        } else {
            border.removeFromSuperlayer()
        }
    }
    
    func flip() {
        designedImageView.transform = designedImageView.transform.scaledBy(x: -1,
                                                                           y: 1)
    }
    
    func rotate() {
        guard let image = designedImageView.image else { return }
        let rotatedImage = image.rotate(radians: .pi / 2)
        designedImageView.image = rotatedImage
        layoutWithImage(image: rotatedImage)
    }
    
    var hasImage: Bool { designedImageView.image != nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let image = designedImageView.image else {
            return
        }
        layoutWithImage(image: image)
    }
}

// MARK: UIScrollViewDelegate
extension DesignScrolledImage: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    designedImageView
  }
}

extension DesignScrolledImage: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

extension Reactive where Base: DesignScrolledImage {
    var image: BindingTarget<UIImage?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            base.addImage(value)
        }
    }
    
    var deleteImage: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.designedImageView.image = nil
        }
    }
    
    var flip: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.flip()
        }
    }
    
    var rotate: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.rotate()
        }
    }
}
