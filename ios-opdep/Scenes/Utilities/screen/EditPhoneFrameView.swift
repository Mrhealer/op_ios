//
//  EditPhoneFrameView.swift
//  ios-opdep
//
//  Created by VMO on 6/16/21.
//

import UIKit

class EditPhoneFrameView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    var view: UIView!
    fileprivate(set) var nibName: String!
    
    var didTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
        xibSetup()
    }
    
    fileprivate func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.isUserInteractionEnabled = true
        addSubview(view)
        didLoadFromNib()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            return view
        }
        return UIView()
    }
    
    func initialize() {
        nibName = "\(self.classForCoder)"
    }
    
    func didLoadFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        didTap?()
    }
}

extension EditPhoneFrameView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
