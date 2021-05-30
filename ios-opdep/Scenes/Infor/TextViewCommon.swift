//
//  TextViewCommon.swift
//  ios-opdep
//
//  Created by Healer on 29/05/2021.
//

import UIKit

class TextViewCommon: UIView {

    @IBOutlet weak var imageLeft: UIImageView!
    @IBOutlet weak var textTitle: UILabel!
    var view: UIView!
    @IBOutlet weak var imageRight: UIImageView!
    fileprivate(set) var nibName: String!
        
    @IBOutlet weak var underLine: UIView!
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
        func didLoadFromNib() {}

}
