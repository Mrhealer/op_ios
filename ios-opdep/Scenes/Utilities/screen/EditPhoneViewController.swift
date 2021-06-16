//
//  EditPhoneViewController.swift
//  ios-opdep
//
//  Created by VMO on 6/11/21.
//

import UIKit
import SwiftyJSON

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
    
    let viewModel: TemplateViewModel
    let template: TemplateCategoryData
    let phoneImageData: PhoneListTemplateData
    var layer: PhoneFrameLayerModel?
    
    var widthBackground: CGFloat = 0
    var heightBackground: CGFloat = 0
    
    var listFrameView: [EditPhoneFrameView] = []
    var indexSelectFrame = 0
    
    init(viewModel: TemplateViewModel, template: TemplateCategoryData, phoneImageData: PhoneListTemplateData) {
        self.viewModel = viewModel
        self.template = template
        self.phoneImageData = phoneImageData
        super.init(nibName: "EditPhoneViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    @IBAction func onPressBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPressDone(_ sender: Any) {
        
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
            }
            self.present(cropVC, animated: true, completion: nil)
        }
    }
    
}
