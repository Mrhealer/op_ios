//
//  CropViewController.swift
//  ios-opdep
//
//  Created by VMO on 6/16/21.
//

import UIKit

class CropViewController: UIViewController {
    
    @IBOutlet weak var cropViewContainer: UIView!
    
    var image: UIImage
    
    var cropView: FMCropView!
    var croppable: FMCroppable
    
    var didCrop: ((_ image: UIImage) -> Void)?
    
    init(image: UIImage, frameWidth: CGFloat, frameHeight: CGFloat) {
        self.image = image
        croppable = FMCrop.ratioCustom(width: frameWidth, height: frameHeight)
        super.init(nibName: "CropViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCrop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCrop()
    }
    
    
    func setupCrop() {
        cropView = FMCropView(image: image,
                              appliedCrop: croppable,
                              appliedCropArea: nil)
        cropViewContainer.addSubview(cropView)
        cropView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: cropView!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cropViewContainer, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cropView!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cropViewContainer, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cropView!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cropViewContainer, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cropView!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cropViewContainer, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0).isActive = true
        
        cropView.foregroundView.compareView.image = image
    }
    
    func showCrop() {
        cropView.frame.size = cropViewContainer.frame.size
        cropView.contentFrame = CGRect(x: 0, y: 0, width: cropViewContainer.frame.width, height: cropViewContainer.frame.height)
        cropView.moveCroppedContentToCenterAnimated()
        cropView.isCropping = true
        
        // disable foreground touches to return control to scrollview
        cropView.foregroundView.isEnabledTouches = false
    }
    
    func cropFinish() {
        cropView.isCropping = false
        let newImage = performCrop(source: image, cropArea: cropView.getCropArea())
        didCrop?(newImage)
    }
    
    func performCrop(source image: UIImage, cropArea: FMCropArea) -> UIImage {
        return croppable.crop(image: image,
                              toRect: cropArea.area(forSize: image.size))
    }
    
    @IBAction func onPressCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPressDone(_ sender: Any) {
        cropFinish()
        self.dismiss(animated: true, completion: nil)
    }
}
