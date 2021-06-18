//
//  EditPhoneViewController.swift
//  ios-opdep
//
//  Created by VMO on 6/11/21.
//

import UIKit
import SwiftyJSON
import SnapKit

struct PhoneFrameLayerModel {
    let background: String?
    let mask: String?
    let color: String?
    let width: CGFloat
    let height: CGFloat
    let frames: [PhoneFrameModel]
    
    init(json: JSON) {
        background = json["background"].string
        mask = json["mask"].string
        color = json["color"].string
        width = CGFloat(json["width"].floatValue)
        height = CGFloat(json["height"].floatValue)
        frames = json["frames"].arrayValue.map({ PhoneFrameModel(json: $0) })
    }
}

struct PhoneFrameModel {
    let onTop: Int
    let centerX: CGFloat
    let centerY: CGFloat
    let width: CGFloat
    let height: CGFloat
    let parentWidth: CGFloat
    let parentHeight: CGFloat
    let angle: CGFloat
    
    var x: CGFloat {
        return centerX - width / 2
    }
    
    var y: CGFloat {
        return centerY - height / 2
    }
    
    init(json: JSON) {
        onTop = json["onTop"].intValue
        centerX = CGFloat(json["centerX"].floatValue)
        centerY = CGFloat(json["centerY"].floatValue)
        width = CGFloat(json["width"].floatValue)
        height = CGFloat(json["height"].floatValue)
        parentWidth = CGFloat(json["parentWidth"].floatValue)
        parentHeight = CGFloat(json["parentHeight"].floatValue)
        angle = CGFloat(json["angle"].floatValue)
    }
}

class EditPhoneViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addTextView: UIView!
    @IBOutlet weak var addStickerView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    let viewModel: TemplateViewModel
    let template: TemplateCategoryData
    let phoneImageData: PhoneListTemplateData
    var layer: PhoneFrameLayerModel?
    
    var widthBackground: CGFloat = 0
    var heightBackground: CGFloat = 0
    
    var listFrameView: [EditPhoneFrameView] = []
    var indexSelectFrame = 0
    
    private var textColor = UIColor.black
    private var isTyping = false
    private var activeTextView: UITextView?
    private var lastPanPoint: CGPoint?
    
    private let stickerView: StickerSelection
    private let stickerSelectionViewModel: StickerSelectionViewModel
    private var bottomStickerSelectionConstraint: Constraint?
    
    init(viewModel: TemplateViewModel, template: TemplateCategoryData, phoneImageData: PhoneListTemplateData) {
        self.viewModel = viewModel
        self.template = template
        self.phoneImageData = phoneImageData
        stickerSelectionViewModel = .init(apiService: APIService.shared)
        stickerView = .init(viewModel: stickerSelectionViewModel)
        super.init(nibName: "EditPhoneViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = phoneImageData.name
        
        if let data = Data(base64Encoded: template.context) {
            let json = try? JSON(data: data)
            guard let frameLayer = json?["frameLayer"] else {
                return
            }
            layer = PhoneFrameLayerModel(json: frameLayer)
        }
        
        if let url = URL(string: layer?.mask ?? "") {
            backgroundImageView.sd_setImage(with: url, completed: nil)
        }
        if let url = URL(string: phoneImageData.editor[1].image ?? "") {
            phoneImageView.sd_setImage(with: url, completed: nil)
        }
        
        let tapAddText = UITapGestureRecognizer(target: self, action: #selector(self.tappedAddText(_:)))
        addTextView.isUserInteractionEnabled = true
        addTextView.addGestureRecognizer(tapAddText)
        
        let tapAddSticker = UITapGestureRecognizer(target: self, action: #selector(self.tappedAddSticker(_:)))
        addStickerView.isUserInteractionEnabled = true
        addStickerView.addGestureRecognizer(tapAddSticker)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(stickerView)
        stickerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(240)
            bottomStickerSelectionConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        
        stickerSelectionViewModel.isSelected.signal.observeValues { [weak self] in
            if $0, let sself = self {
                sself.showSelection(selection: sself.stickerView,
                                    contraint: sself.bottomStickerSelectionConstraint)
            }
        }
        
        stickerSelectionViewModel.takePhotoAction.values.observeValues { [weak self] in
            self?.openLibrary()
        }
        
        stickerSelectionViewModel.selectedSticker.observeValues { [weak self] url in
            guard let self = self, let url = url else { return }
            let imageView = UIImageView()
            imageView.frame.size = CGSize(width: 100, height: 100)
            imageView.af.setImage(withURL: url)
            self.containerView.addSubview(imageView)
            imageView.center = CGPoint(x: self.containerView.frame.width / 2, y: self.containerView.frame.height / 2)
            self.addGestures(view: imageView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let layer = self.layer else { return }
        
        listFrameView.forEach({ $0.removeFromSuperview() })
        listFrameView.removeAll()
        
        widthBackground = backgroundImageView.frame.width
        heightBackground = layer.height / layer.width * widthBackground
        backgroundHeightConstraint.constant = heightBackground
        view.layoutIfNeeded()
        
        for (index, frame) in layer.frames.enumerated() {
            let view = EditPhoneFrameView()
            let scaleX = frame.parentWidth / widthBackground
            let scaleY = frame.parentHeight / heightBackground
            view.frame.size = CGSize(width: frame.width / scaleX, height: frame.height / scaleY)
            view.frame.origin.x = frame.x / scaleX
            view.frame.origin.y = frame.y / scaleY
            view.transform = view.transform.rotated(by: frame.angle / 180 * .pi)
            backgroundImageView.addSubview(view)
            
            view.didTap = { [weak self] in
                self?.indexSelectFrame = index
                self?.openLibrary()
            }
            listFrameView.append(view)
        }
    }
    
    private func openLibrary() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true)
    }
    
    private func showSelection(selection: UIView, contraint: Constraint?) {
        animateView(with: contraint,
                    offset: 240,
                    animatedDuration: 0,
                    completion: { [weak self, selection] in
                        selection.isHidden = false
                        self?.animateView(with: contraint,
                                         offset: 0)
        })
    }
    
    private func updateContraint(contraint: Constraint?, offset: CGFloat) {
        contraint?.update(offset: offset)
    }
    
    func animateView(with contraint: Constraint?,
                     offset: CGFloat,
                     animatedDuration: TimeInterval = 0.3,
                     completion: (() -> Void)? = nil) {
        updateContraint(contraint: contraint,
                        offset: offset)
        UIView.animate(withDuration: animatedDuration,
                       animations: { [weak self] in
                        guard let sself = self else { return }
                        sself.view.layoutIfNeeded()
            },
                       completion: { _ in
                        guard let completion = completion else { return }
                        completion()
        })
    }
    
    @objc func keyboardDidShow() {
        if isTyping {
            doneButton.setTitle("Xong", for: .normal)
            doneButton.setImage(nil, for: .normal)
        }
    }
    
    @objc func keyboardWillHide() {
        doneButton.setImage(R.image.navigation_next(), for: .normal)
        doneButton.setTitle(nil, for: .normal)
        isTyping = false
    }
    
    @objc func tappedAddText(_ sender: UITapGestureRecognizer) {
        addText()
    }
    
    @objc func tappedAddSticker(_ sender: UITapGestureRecognizer) {
        stickerSelectionViewModel.isSelected.value = true
    }

    @IBAction func onPressBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPressDone(_ sender: Any) {
        if isTyping {
            view.endEditing(true)
            return
        }
        
        let buyRouter = BuyRouter(navigationController)
        let preview = containerView.imageFromView(scale: 0.75)
        let image = CommonUtility.createPdfFromView(designLayer: containerView.layer,
                                                    desginBounds: containerView.bounds)
        phoneImageView.isHidden = true
        let print = CommonUtility.createPdfFromView(designLayer: containerView.layer,
                                                    desginBounds: containerView.bounds)
        let designModel = OutPutFileModel(preview: preview, photo: image, print: print)
        // ko sử dụng product để làm gì
        let product = ProductModel(id: Int64(phoneImageData.id), name: nil, imgUrl: nil, price: nil, priceDiscount: nil, editor: nil)
        buyRouter.start(productModel: product, outPutFile: designModel)
    }
}

extension EditPhoneViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self, let image = info[.originalImage] as? UIImage else {
                return
            }
            let cropVC = CropViewController(image: image, frameWidth: self.layer?.frames[self.indexSelectFrame].width ?? 0, frameHeight: self.layer?.frames[self.indexSelectFrame].height ?? 0)
            cropVC.didCrop = { [weak self] newImage in
                guard let self = self else { return }
                let view = self.listFrameView[self.indexSelectFrame]
                view.imageView.image = newImage
                view.imageHeightConstraint.constant = newImage.size.height / newImage.size.width * view.imageView.frame.width
                view.addImage.isHidden = true
            }
            self.present(cropVC, animated: true, completion: nil)
        }
    }
    
}

extension EditPhoneViewController: UITextViewDelegate {
    
    func addText() {
        isTyping = true
        let textView = UITextView(frame: CGRect(x: 0, y: containerView.center.y,
                                                width: containerView.frame.width, height: 30))
        
        textView.textAlignment = .center
        textView.font = UIFont(name: "Helvetica", size: 30)
        textView.textColor = textColor
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowRadius = 1.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        
        self.containerView.addSubview(textView)
        addGestures(view: textView)
        textView.becomeFirstResponder()
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        let rotation = atan2(textView.transform.b, textView.transform.a)
        if rotation == 0 {
            let oldFrame = textView.frame
            let sizeToFit = textView.sizeThatFits(CGSize(width: oldFrame.width, height: CGFloat.greatestFiniteMagnitude))
            textView.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isTyping = true
        activeTextView = textView
        textView.superview?.bringSubviewToFront(textView)
        // TODO: remove this if don't need change font when edit
        textView.font = UIFont(name: "Helvetica", size: 30)
        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        textView.transform = CGAffineTransform.identity
                        textView.center = CGPoint(x: self.containerView.frame.width / 2,
                                                  y: self.containerView.frame.height / 2)
        })
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
    }
    
    func addGestures(view: UIView) {
        //Gestures
        view.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(self.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(self.pinchGesture))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                                    action: #selector(self.rotationGesture))
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }
}

extension EditPhoneViewController: UIGestureRecognizerDelegate {
    
    /**
     UIPanGestureRecognizer - Moving Objects
     Selecting transparent parts of the imageview won't move the object
     */
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if let view = recognizer.view {
            moveView(view: view, recognizer: recognizer)
        }
    }
    
    /**
     UIPinchGestureRecognizer - Pinching Objects
     If it's a UITextView will make the font bigger so it doen't look pixlated
     */
    @objc func pinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            if let textView = view as? UITextView {
                
                if textView.font!.pointSize * recognizer.scale < 90 {
                    let font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize * recognizer.scale)
                    textView.font = font
                    let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                 height: CGFloat.greatestFiniteMagnitude))
                    textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                                  height: sizeToFit.height)
                } else {
                    let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                 height: CGFloat.greatestFiniteMagnitude))
                    textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                                  height: sizeToFit.height)
                }
                
                textView.setNeedsDisplay()
            } else {
                view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            }
            recognizer.scale = 1
        }
    }
    
    /**
     UIRotationGestureRecognizer - Rotating Objects
     */
    @objc func rotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    /**
     UITapGestureRecognizer - Taping on Objects
     Will make scale scale Effect
     Selecting transparent parts of the imageview won't move the object
     */
    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view {
            if view is UIImageView {
                //Tap only on visible parts on the image
                for imageView in subImageViews(view: containerView) {
                    let location = recognizer.location(in: imageView)
                    let alpha = imageView.alphaAtPoint(location)
                    if alpha > 0 {
                        scaleEffect(view: imageView)
                        break
                    }
                }
            } else {
                scaleEffect(view: view)
            }
        }
    }
    
    /*
     Support Multiple Gesture at the same time
     */
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    /**
     Scale Effect
     */
    func scaleEffect(view: UIView) {
        view.superview?.bringSubviewToFront(view)
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let previouTransform =  view.transform
        UIView.animate(withDuration: 0.2,
                       animations: {
                        view.transform = view.transform.scaledBy(x: 1.2, y: 1.2)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            view.transform  = previouTransform
                        }
        })
    }
    
    /**
     Moving Objects
     delete the view if it's inside the delete view
     Snap the view back if it's out of the canvas
     */
    
    func moveView(view: UIView, recognizer: UIPanGestureRecognizer) {
        
        guard let superView = view.superview else {
            return
        }
        
        //        hideToolbar(hide: true)
        deleteView.isHidden = false
        
        view.superview?.bringSubviewToFront(view)
        let pointToSuperView = recognizer.location(in: self.view)
        
        view.center = CGPoint(x: view.center.x + recognizer.translation(in: superView).x,
                              y: view.center.y + recognizer.translation(in: superView).y)
        
        recognizer.setTranslation(CGPoint.zero, in: superView)
        
        if let previousPoint = lastPanPoint {
            //View is going into deleteView
            if deleteView.frame.contains(pointToSuperView) && !deleteView.frame.contains(previousPoint) {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = view.transform.scaledBy(x: 0.25, y: 0.25)
                    view.center = recognizer.location(in: superView)
                })
            }
                //View is going out of deleteView
            else if deleteView.frame.contains(previousPoint) && !deleteView.frame.contains(pointToSuperView) {
                //Scale to original Size
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = view.transform.scaledBy(x: 4, y: 4)
                    view.center = recognizer.location(in: superView)
                })
            }
        }
        lastPanPoint = pointToSuperView
        
        if recognizer.state == .ended {
            lastPanPoint = nil
            deleteView.isHidden = true
            let point = recognizer.location(in: self.view)
            
            if deleteView.frame.contains(point) { // Delete the view
                view.removeFromSuperview()
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            } else  { //Snap the view back to canvasView
                let point: CGPoint = view.center
                if !superView.bounds.contains(point) {
                    UIView.animate(withDuration: 0.3, animations: {
                        view.center = CGPoint(x: superView.frame.width / 2, y: superView.frame.height / 2)
                    })
                }
                
            }
        }
    }
    
    func subImageViews(view: UIView) -> [UIImageView] {
        var imageviews: [UIImageView] = []
        for imageView in view.subviews {
            if let view = imageView as? UIImageView, imageView != backgroundImageView {
                imageviews.append(view)
            }
        }
        return imageviews
    }
    
}

extension UIImageView {
    
    func alphaAtPoint(_ point: CGPoint) -> CGFloat {
        
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let alphaInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: alphaInfo) else {
            return 0
        }
        
        context.translateBy(x: -point.x, y: -point.y);
        
        layer.render(in: context)
        
        let floatAlpha = CGFloat(pixel[3])
        
        return floatAlpha
    }

}
