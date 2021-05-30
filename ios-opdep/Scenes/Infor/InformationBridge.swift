//
//  InformationBridge.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 5/28/21.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift
import SkyFloatingLabelTextField

class InformationBridge : BasicViewController{
    override var shouldHideNavigationBar: Bool { true }
    let viewModel: InformationViewModel
    
    
    var arrayItemInfo = [ItemInformation]()
    var arraySettings = [ItemInformation]()
    
    init(viewModel: InformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        bindViewModel(viewModel)
        view.backgroundColor = UIColor.Basic.white
        prepare()
    }
    
    func prepare() {
        let safeAreaView = StyleView(backgroundColor: .init(hexString: "8D7AA5"))
        let headerView = buildHeader()
        let buildViewInfor = buildInformationView()
        let tableView = tableCell()
        
        let inforOrder = ItemInformation(imageLeft: R.image.info(), strTitle: Localize.InfomationAccount.receivedOrder, imageRight:  R.image.next())
        
        let inforCard = ItemInformation(imageLeft: R.image.tabbar_cart_active(), strTitle: Localize.InfomationAccount.cardOrder, imageRight:  R.image.next())
        
        let inforHistory = ItemInformation(imageLeft: R.image.tabbar_history_active(), strTitle: Localize.InfomationAccount.historyOrder, imageRight:  R.image.next())
        
        let inforInstagram = ItemInformation(imageLeft: R.image.instagram(), strTitle: Localize.InfomationAccount.instagram, imageRight:  R.image.next())
        
        let inforFacebook = ItemInformation(imageLeft: R.image.facebook(), strTitle: Localize.InfomationAccount.facebook, imageRight:  R.image.next())
        
        let inforShared = ItemInformation(imageLeft: R.image.share(), strTitle: Localize.InfomationAccount.share, imageRight:  R.image.next())
        
        arrayItemInfo = [inforOrder,inforCard,inforHistory,inforInstagram,inforFacebook,inforShared]
        
        arraySettings = [inforOrder,inforCard,inforHistory]
        
        view.addSubviews(safeAreaView,headerView,buildViewInfor)
        safeAreaView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(headerView.snp.top)
        }
        headerView.snp.makeConstraints {
            $0.height.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
    }
    
    func buildHeader() -> UIView {
        let container = StyleView(backgroundColor: .init(hexString: "F5F5F5"))
        container.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        container.clipsToBounds = true
        container.layer.cornerRadius = 24
        container.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        return container
    }
    
    
    
    func buildTitlte() -> UILabel{
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: self.view.frame.width, height:20))
        label.textAlignment = .left
        label.text = Localize.InfomationAccount.titleInfor
        label.font = R.font.openSansRegular(size: 16)
        return label
    }
    
    func buildTitleSetting() -> UILabel{
        let label = UILabel(frame: CGRect(x: 20, y: 300, width: self.view.frame.width, height:20))
        label.textAlignment = .left
        label.text = Localize.InfomationAccount.titleSettings
        label.font = R.font.openSansRegular(size: 16)
        return label
    }
    
    func buildInformationView() -> UIView{
        let view = UIView.init(frame: CGRect.init(x: 20, y: 120, width:  self.view.frame.width * 0.9, height: 300))
        self.view.addSubview(view)
        view.layer.borderColor = UIColor(hexString: "C4C4C4").cgColor
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = true
        view.center.x = self.view.center.x
        return view
    }
    
    
    
    func tableCell() -> UITableView{
        let view = UITableView(frame: CGRect.init(x: 20, y: 120, width:  self.view.frame.width * 0.9, height:600))
        view.delegate = self
        view.dataSource = self
        view.register(UINib(nibName: "InformationCell", bundle: nil), forCellReuseIdentifier: "InformationCell")
        return view
    }
    
    func tableCellSettings() -> UITableView{
        let view = UITableView(frame: CGRect.init(x: 20, y: 120, width:  self.view.frame.width * 0.9, height:300))
        
        return view
    }
    
}

extension InformationBridge:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return arrayItemInfo.count - 1
        }else {
            return arraySettings.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as? InformationCell else {
            return UITableViewCell()
        }
        
        if (indexPath.section == 0) {
            cell.img_left.image = arrayItemInfo[indexPath.row].imageLeft
            cell.txt_title?.text = arrayItemInfo[indexPath.row].title
            cell.img_right.image = arrayItemInfo[indexPath.row].imageRight
            cell.txt_title.font = R.font.openSansBold(size: 16)
        } else {
            cell.img_left.image = arraySettings[indexPath.row].imageLeft
            cell.txt_title?.text = arraySettings[indexPath.row].title
            cell.img_right.image = arraySettings[indexPath.row].imageRight
            cell.txt_title.font = R.font.openSansBold(size: 16)
        }
        
        
        return cell
    }
    
    
    
}

extension InformationBridge:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0){
            return buildTitlte()
        }else{
            return buildTitleSetting()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell.responds(to: #selector(getter: UIView.tintColor))) {
            let cornerRadius: CGFloat = 5
            cell.backgroundColor = UIColor.clear
            let layer: CAShapeLayer  = CAShapeLayer()
            let pathRef: CGMutablePath  = CGMutablePath()
            let bounds: CGRect  = cell.bounds.insetBy(dx: 10, dy: 0)
            var addLine: Bool  = false
            if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
                pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
            } else if (indexPath.row == 0) {
                pathRef.move(to: CGPoint(x:bounds.minX,y:bounds.maxY))
                pathRef.addArc(tangent1End: CGPoint(x:bounds.minX,y:bounds.minY), tangent2End: CGPoint(x:bounds.midX,y:bounds.minY), radius: cornerRadius)

                pathRef.addArc(tangent1End: CGPoint(x:bounds.maxX,y:bounds.minY), tangent2End: CGPoint(x:bounds.maxX,y:bounds.midY), radius: cornerRadius)
                pathRef.addLine(to: CGPoint(x:bounds.maxX,y:bounds.maxY))
                addLine = true;
            } else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {

                pathRef.move(to: CGPoint(x:bounds.minX,y:bounds.minY))
                pathRef.addArc(tangent1End: CGPoint(x:bounds.minX,y:bounds.maxY), tangent2End: CGPoint(x:bounds.midX,y:bounds.maxY), radius: cornerRadius)

                pathRef.addArc(tangent1End: CGPoint(x:bounds.maxX,y:bounds.maxY), tangent2End: CGPoint(x:bounds.maxX,y:bounds.midY), radius: cornerRadius)
                pathRef.addLine(to: CGPoint(x:bounds.maxX,y:bounds.minY))

            } else {
                pathRef.addRect(bounds)
                addLine = true
            }
            layer.path = pathRef
            //CFRelease(pathRef)
            //set the border color
            layer.strokeColor = UIColor.lightGray.cgColor;
            //set the border width
            layer.lineWidth = 1
            layer.fillColor = UIColor(white: 1, alpha: 1.0).cgColor


            if (addLine == true) {
                let lineLayer: CALayer = CALayer()
                let lineHeight: CGFloat  = (1 / UIScreen.main.scale)
                lineLayer.frame = CGRect(x:bounds.minX, y:bounds.size.height-lineHeight, width:bounds.size.width, height:lineHeight)
                lineLayer.backgroundColor = tableView.separatorColor!.cgColor
                layer.addSublayer(lineLayer)
            }

            let testView: UIView = UIView(frame:bounds)
            testView.layer.insertSublayer(layer, at: 0)
            testView.backgroundColor = UIColor.clear
            cell.backgroundView = testView
        }

    }
}

class ItemInformation : NSObject{
    var imageLeft : UIImage?
    var title : String?
    var imageRight : UIImage?
    init(imageLeft: UIImage?,strTitle : String?, imageRight: UIImage?) {
        self.imageLeft = imageLeft
        self.title = strTitle
        self.imageRight = imageRight
    }
}
