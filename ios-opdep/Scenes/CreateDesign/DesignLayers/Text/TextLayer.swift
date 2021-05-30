//
//  TextLayer.swift
//  OPOS
//
//  Created by Tran Van Dinh on 10/23/20.
//  Copyright © 2020 eglifevn. All rights reserved.
//

import Foundation
import ReactiveSwift

class TextLayer: ContainerLayerCommon<TextTransformable> {
    let viewModel: TextLayerViewModel
    
    init(viewModel: TextLayerViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        reactive.changedtext <~ viewModel.changedText
        reactive.addText <~ viewModel.addText.signal
        reactive.font <~ viewModel.fetchFontAction.values.signal.skipNil()
        reactive.textAlignment <~ viewModel.changedAlign.signal.skipNil()
        reactive.textCased <~ viewModel.changedTextCased.signal.skipNil()
        reactive.color <~ viewModel.changedColor.signal.skipNil()
        reactive.attributes <~ viewModel.applyAttributesAction.values.skipNil()
        reactive.fontSize <~ viewModel.fontSizeValue
        reactive.deselect <~ viewModel.deselect
        viewModel.templateLabels.producer.startWithValues { [weak self] in
            self?.drawTemplateLabels(labelModels: $0)
        }
    }
    
    override func layout(with design: TextTransformable) {
        let size = design.labelContent.intrinsicContentSize
        design.frame = CGRect(origin: .zero,
                              size: CGSize(width: size.width + 60,
                                           height: size.height + 40))
        let center = CGPoint(x: frame.width / 2,
                             y: frame.height / 2)
        design.center = center
    }
    
    func removeDefaultLabels() {
        for subview in subviews {
            if let label = subview as? TextTransformable, label.labelContent.text == AppConstants.CreateDesign.defaultText {
                label.removeFromSuperview()
            }
        }
    }
    
    func add(text: String) {
        let label = TextTransformable(text: text)
        viewModel.deletedLabel <~ label.closeGesture.reactive.stateChanged
            .filter { $0.state == .ended }
            .map { _ in }
        let tapped = UITapGestureRecognizer(target: self,
                                            action: #selector(tappedLabel(_:)))
        tapped.numberOfTapsRequired = 1
        label.addGestureRecognizer(tapped)
        
        add(design: label)
        viewModel.currentStyles.swap(label.styles)
        viewModel.currentFontSize.swap(label.fontSize)
        viewModel.selectedNewLabel.swap(true)
        viewModel.editedText.swap(text)
    }
    
    @objc func tappedLabel(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? TextTransformable else {
            return
        }
        if selectedView != label {
            viewModel.deletedLabel <~ label.closeGesture.reactive.stateChanged
            .filter { $0.state == .ended }
            .map { _ in }
        }
        selected(design: label)
        viewModel.currentStyles.swap(label.styles)
        viewModel.currentFontSize.swap(label.fontSize)
        viewModel.selectedNewLabel.swap(true)
        bringSubviewToFront(label)
        viewModel.editedText.swap(label.labelContent.text)
    }
    
    var shouldAddDefaultLabel: Bool {
        for subview in subviews where subview as? TextTransformable != nil {
            return false
        }
        return true
    }
    
    func updateText(text: String?) {
        guard let selectedLabel = selectedView else { return }
        selectedLabel.labelContent.text = text
        if let text = text, !text.isEmpty {
            let height = selectedLabel.apply(styles: selectedLabel.styles)
            selectedLabel.bounds = CGRect(origin: .zero,
                                    size: CGSize(width: selectedLabel.bounds.width,
                                                 height: height + 40))
        }
    }
    
    func deleteText() {
        if selectedView != nil {
            removeSelectedView()
            return
        }
        for subview in subviews where subview as? TextTransformable != nil {
            subview.removeFromSuperview()
            break
        }
    }
    
    func shouldAdjustWith(height: CGFloat) -> Bool {
        guard let selectedText = selectedView else {
            return false
        }
        // convert origin of selected text to screen
        let origin = self.convert(selectedText.frame.origin, to: nil)
        // giá trị 15 coi như space ở bottom của label so với text thực sự
        let textBottom = origin.y + selectedText.frame.height - 15
        let startY = UIScreen.main.bounds.height - height
        if textBottom > startY { return true }
        return false
    }
    
    func drawTemplateLabels(labelModels: [LabelModel]?) {
        for subview in subviews where subview as? TextTransformable != nil {
            subview.removeFromSuperview()
        }
        let extraSpace: CGFloat = 0
        guard let labelModels = labelModels else { return }
        for labelModel in labelModels {
            let ratioStandard = labelModel.parentWidth / labelModel.parentHeight
            let ratioDesign = (bounds.width - extraSpace) / (bounds.height - extraSpace)
            var designHeight = bounds.height - extraSpace
            var designWidth = designHeight * ratioStandard
            if ratioStandard <= ratioDesign {
                designWidth = bounds.width - extraSpace
                designHeight = designWidth / ratioStandard
            }
            let fontSize = labelModel.fontSize * designHeight / labelModel.parentHeight
            var textAlignment: NSTextAlignment = .center
            if let alignment = labelModel.alignment {
                textAlignment = alignment.alignment
            }
            let label = TextTransformable(text: labelModel.text,
                                          size: Float(fontSize),
                                          fontName: labelModel.font,
                                          textColor: .init(hexString: labelModel.color),
                                          textAlignment: textAlignment)
            addSubview(label)
            
            let width = designWidth * labelModel.scaleW
            let height = designHeight * labelModel.scaleH
            let offsetX = (bounds.width - designWidth) / 2
            let offsetY = (bounds.height - designHeight) / 2
            label.frame = CGRect(origin: .zero,
                                 size: CGSize(width: width + 20,
                                              height: height + 20))
            let frameCenterX = designWidth * labelModel.scaleX
            let frameCenterY = designHeight * labelModel.scaleY
            let center = CGPoint(x: frameCenterX + offsetX,
                                 y: frameCenterY + offsetY)
            label.center = center
            
            viewModel.deletedLabel <~ label.closeGesture.reactive.stateChanged
                .filter { $0.state == .ended }
                .map { _ in }
            let tapped = UITapGestureRecognizer(target: self,
                                                action: #selector(tappedLabel(_:)))
            tapped.numberOfTapsRequired = 1
            label.addGestureRecognizer(tapped)
            label.showEditingHandlers(status: false)
            label.setEnableMove(true)
            label.transform = label.transform.rotated(by: .pi * labelModel.angle / 180)
            
            viewModel.currentStyles.swap(label.styles)
            viewModel.currentFontSize.swap(label.fontSize)
        }
    }
    
    func deselect() {
        configureSelectedView(selected: false)
    }
    
    func createLabelModel() -> [LabelModel]? {
        let labels = subviews.filter { $0 as? TextTransformable != nil }
        guard labels.count > 0 else { return nil }
        var labelModels: [LabelModel] = []
        for label in labels {
            if let label = label as? TextTransformable {
                let centerX: CGFloat = label.center.x
                let centerY: CGFloat = label.center.y
                var width: CGFloat = label.frame.width - 20
                var height: CGFloat = label.frame.height
                let parentWidth: CGFloat = self.frame.width
                let parentHeight: CGFloat = self.frame.height
                let radians = atan2(label.transform.b, label.transform.a)
                let degrees = radians * 180 / .pi
                let angle: CGFloat = degrees
                let transform = label.transform
                label.transform = .identity
                width = label.frame.width
                height = label.frame.height
                label.transform = transform
                
                let fontSize: CGFloat = label.labelContent.font.pointSize
                let text: String = label.labelContent.text ?? ""
                let color: String = label.labelContent.textColor.hexStringFromColor()
                let font: String? = label.labelContent.font.fontName
                let alignment: TextAlignment? = .center
                
                let labelModel = LabelModel(centerX: centerX,
                                            centerY: centerY,
                                            width: width,
                                            height: height,
                                            parentWidth: parentWidth,
                                            parentHeight: parentHeight,
                                            angle: angle,
                                            fontSize: fontSize,
                                            text: text,
                                            color: color,
                                            font: font,
                                            alignment: alignment)
                labelModels.append(labelModel)
            }
        }
        return labelModels
    }
}

extension Reactive where Base: TextLayer {
    var text: BindingTarget<String> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            base.add(text: value)
        }
    }
    
    var changedtext: BindingTarget<String?> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            base.updateText(text: value)
        }
    }
    
    var deleteText: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.deleteText()
        }
    }
    
    var addText: BindingTarget<()> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.add(text: AppConstants.CreateDesign.defaultText)
        }
    }
    
    var font: BindingTarget<String> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let current = base.selectedView else { return }
            current.labelContent.font = UIFont(name: value,
                                               size: current.labelContent.font.pointSize)
            let height = current.apply(styles: current.styles)
            current.bounds = CGRect(origin: .zero,
                                    size: CGSize(width: current.bounds.width,
                                                 height: height + 40))
        }
    }
    
    var color: BindingTarget<UIColor> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let current = base.selectedView else { return }
            current.labelContent.textColor = value
        }
    }
    
    var attributes: BindingTarget<(Float, Float, Float)> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let current = base.selectedView else { return }
            let height = current.apply(styles: value)
            current.bounds = CGRect(origin: .zero,
                                    size: CGSize(width: current.bounds.width,
                                                 height: height + 40))
        }
    }
    
    var fontSize: BindingTarget<Float> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let current = base.selectedView else { return }
            current.fontSize = value
            current.labelContent.font = current.labelContent.font.withSize(CGFloat(value))
            let height = current.apply(styles: current.styles)
            current.bounds = CGRect(origin: .zero,
                                    size: CGSize(width: current.bounds.width,
                                                 height: height + 40))
        }
    }
    
    var textAlignment: BindingTarget<NSTextAlignment> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let current = base.selectedView else { return }
            current.labelContent.textAlignment = value
        }
    }
    
    var textCased: BindingTarget<TextCased> {
        makeBindingTarget(on: UIScheduler()) { base, value in
            guard let current = base.selectedView else { return }
            let text: String = current.labelContent.text.asStringOrEmpty()
            switch value {
            case TextCased.capitalized:
                current.labelContent.text = text.capitalized
            case .upperCased:
                current.labelContent.text = text.uppercased()
            case .lowerCased:
                current.labelContent.text = text.lowercased()
            }
        }
    }
    
    var deselect: BindingTarget<Void> {
        makeBindingTarget(on: UIScheduler()) { base, _ in
            base.deselect()
        }
    }
}
