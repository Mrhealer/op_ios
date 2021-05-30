//
//  TestViewController.swift
//  ios-opdep
//
//  Created by Healer on 29/05/2021.
//

import UIKit
import ReactiveCocoa

class TestViewController: BasicViewController {
    
    
    
    @IBOutlet weak var textSettings: UILabel!
    
    @IBOutlet weak var stackViewInfo: UIStackView!
    
    @IBOutlet weak var stackViewSettings: UIStackView!
    
    @IBOutlet weak var textTitle: UILabel!
    let viewModel: InformationViewModel
    
    var arrayItemInfo = [ItemInformation]()
    var arraySettings = [ItemInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        arrayItemInfo = [inforOrder,inforCard,inforHistory,inforInstagram,inforFacebook,inforShared]
        
        arraySettings = [inforTerm,inforSurvey,inforAuth]
        
        for (index, item) in arrayItemInfo.enumerated() {
            let view = TextViewCommon()
            view.layoutMargins = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
            
            view.imageLeft.image = item.imageLeft
            view.textTitle.text = item.title
            view.imageRight.image = item.imageRight
            view.textTitle.font = R.font.openSansRegular(size: 16)
            view.underLine.backgroundColor = .black
            view.snp.makeConstraints{
                $0.height.equalTo(30)
                
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
                $0.height.equalTo(30)
                
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func touchHappen(_ sender: UITapGestureRecognizer) {
        //        arrayItemInfo[sender.view?.tag ?? 0]
        switch sender.view?.tag {
        case 1:
            print("Hello Dear you are here1")
            break
        case 2:
            //            CocoaAction<Any>(viewModel.navigateToOrderHistoryAction)
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
            InformationRouter(AppLogic.shared.appRouter.rootNavigationController).presentSignIn()
            break
        default:
            print("Hello Dear you are here2")
        }
    }
    
}

