//
//  TestViewController.swift
//  ios-opdep
//
//  Created by Healer on 29/05/2021.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import GoogleMobileAds
class TestViewController: BasicViewController, GADBannerViewDelegate {
    
    
    
    @IBOutlet weak var textSettings: UILabel!
    
    @IBOutlet weak var stackViewInfo: UIStackView!
    
    @IBOutlet weak var stackViewSettings: UIStackView!
    
    @IBOutlet weak var textTitle: UILabel!
    
    
    private let banner :GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-7717959238784130/8617340861"
        banner.load(GADRequest())
        
        if #available(iOS 13.0, *) {
            banner.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        } else {
            banner.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
        
        return banner
    }()
    
    let viewModel: InformationViewModel
    
    var arrayItemInfo = [ItemInformation]()
    var arraySettings = [ItemInformation]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: self.view.bounds.size.height-150, width: self.view.bounds.width, height: 50).integral
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stackViewInfo.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        stackViewSettings.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        textTitle.text = Localize.InfomationAccount.titleInfor
        textSettings.text = Localize.InfomationAccount.titleSettings
        textTitle.font = R.font.openSansLightItalic(size: 18)
        textSettings.font = R.font.openSansLightItalic(size: 18)
        
        let inforOrder = ItemInformation(imageLeft: R.image.info(), strTitle: Localize.InfomationAccount.receivedOrder, imageRight:  R.image.next())
        
        let inforCard = ItemInformation(imageLeft: R.image.tabbar_cart_active(), strTitle: Localize.InfomationAccount.cardOrder, imageRight:  R.image.next())
        
        let inforHistory = ItemInformation(imageLeft: R.image.tabbar_history_active(), strTitle: Localize.InfomationAccount.historyOrder, imageRight:  R.image.next())
        
        let inforInstagram = ItemInformation(imageLeft: R.image.instagram(), strTitle: Localize.InfomationAccount.instagram, imageRight:  R.image.next())
        
        let inforFacebook = ItemInformation(imageLeft: R.image.facebook(), strTitle: Localize.InfomationAccount.facebook, imageRight:  R.image.next())
        
        let inforShared = ItemInformation(imageLeft: R.image.share(), strTitle: Localize.InfomationAccount.share, imageRight:  R.image.next())
        
        let inforTerm = ItemInformation(imageLeft: R.image.policy(), strTitle: Localize.InfomationAccount.term, imageRight:  R.image.next())
        
        let inforSurvey = ItemInformation(imageLeft: R.image.survey(), strTitle: Localize.InfomationAccount.survey, imageRight:  R.image.next())
        
        let inforAuth = ItemInformation(imageLeft: R.image.login(), strTitle: Localize.InfomationAccount.auth, imageRight:  R.image.next())
        
        let noLogin = ItemInformation(imageLeft: R.image.login(), strTitle: "Đăng xuất", imageRight:  R.image.next())
        
        let userID = Property(value: APIService.shared.keyStore.userId.asStringOrEmpty())
        
        arrayItemInfo = [inforOrder,inforCard,inforHistory,inforInstagram,inforFacebook,inforShared]
        
        arraySettings = [inforTerm,inforSurvey, userID.value.isEmpty ? inforAuth : noLogin]
        
        for (index, item) in arrayItemInfo.enumerated() {
            let view = TextViewCommon()
            view.layoutMargins = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
            
            view.imageLeft.image = item.imageLeft
            view.textTitle.text = item.title
            view.imageRight.image = item.imageRight
            view.textTitle.font = R.font.openSansRegular(size: 16)
            view.underLine.backgroundColor = .black
            view.snp.makeConstraints{
                $0.height.equalTo(50)
                
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchHappen(_:)))
            view.addGestureRecognizer(tap)
            view.isUserInteractionEnabled = true
            view.tag = index
            
            
            
            stackViewInfo.withBorder(width: 1)
            stackViewInfo.addArrangedSubview(view)
            
        }
        
        
        
        for (index, item) in arraySettings.enumerated() {
            let view = TextViewCommon()
            view.layoutMargins = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
            view.imageLeft.image = item.imageLeft
            view.textTitle.text = item.title
            view.imageRight.image = item.imageRight
            view.textTitle.font = R.font.openSansRegular(size: 16)
            view.snp.makeConstraints{
                $0.height.equalTo(50)
                
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchHappenSettings(_:)))
            view.addGestureRecognizer(tap)
            view.isUserInteractionEnabled = true
            view.tag = index
            view.underLine.backgroundColor = .black
            stackViewSettings.withBorder(width: 1)
            stackViewSettings.addArrangedSubview(view)
        }
        
    }
    
    init(viewModel: InformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TestViewController", bundle: nil)
        
        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func touchHappen(_ sender: UITapGestureRecognizer) {
        //        arrayItemInfo[sender.view?.tag ?? 0]
        switch sender.view?.tag {
        case 0:
            viewModel.startProfile()
            break
        case 1:
            viewModel.startCardOrder()
            break
        case 2:
            viewModel.startOrderHistory()
            break
        case 3:
            let url = URL(string: "https://www.instagram.com/inopdepvn/")
            UIApplication.shared.open(url!)
            break
        case 4:
            let url = URL(string: "https://www.facebook.com/oplungdienthoaidep2021")
            UIApplication.shared.open(url!)
            break
        case 5:
            if let name = URL(string: "https://www.instagram.com/inopdepvn/"), !name.absoluteString.isEmpty {
                let objectsToShare = [name]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            }
            break
        default:
            print("Hello Dear you are here2")
        }
    }
    
    
    @objc func touchHappenSettings(_ sender: UITapGestureRecognizer) {
        //        arrayItemInfo[sender.view?.tag ?? 0]
        switch sender.view?.tag {
        case 0:
            CommonWebViewRouter(AppLogic.shared.appRouter.rootNavigationController).startTerm()
            break
        case 1:
            print("Hello Dear you are here1")
            break
        case 2:
            print("login")
            let userID = Property(value: APIService.shared.keyStore.userId.asStringOrEmpty())
            if userID.value.isEmpty {
                InformationRouter(AppLogic.shared.appRouter.rootNavigationController).presentSignIn()
            } else {
                viewModel.clearToken()
                viewDidLoad()
                InformationRouter(AppLogic.shared.appRouter.rootNavigationController).presentSignIn()
            }
            break
        default:
            print("Hello Dear you are here2")
        }
    }
    
    
}

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addMiddleBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:self.frame.size.width/2, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
}

