//
//  OrderDetailsViewController.swift
//  ios-opdep
//
//  Created by Nguyen Anh on 06/06/2021.
//

import UIKit
import ReactiveSwift
import Nuke
import ReactiveCocoa
import RxSwift

class OrderDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var timeOrderLabel: UILabel!
    @IBOutlet weak var prince: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var priceDiscount: UILabel!
    @IBOutlet weak var deleteOrder: UIButton!
    
    var data = MutableProperty<CartItemViewModel?>(nil)
    var tapDeleteOrder = PublishSubject<Void>()
    let viewModelNew = OrderViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        addObserver()
    }
    
    func loadData() {
        titleHeader.text = "Đơn hàng"
        let model = data.value?.model
        codeLabel.text = String(model?.id ?? 0)
        //status.text = ""
        timeOrderLabel.text = String(format: "Ngày đặt hàng: %@", model?.createdAt ?? "")
        prince.text = String(format: "Thành tiền: %@", UtilityPrice.formatCurrency(currencyString: model?.priceDiscount ?? ""))
        addressLabel.text = ""
        priceDiscount.text = String(format: "%@", UtilityPrice.formatCurrency(currencyString: model?.priceDiscount ?? ""))
        if let urlImage = URL(string: model?.photoUrlPreview ?? "") {
            Nuke.loadImage(with: urlImage, into: imageProduct)
        }
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapCancelOrder(_ sender: Any) {
        viewModelNew.deleteOrder(productId: String(data.value?.model.id ?? 0))
    }
    
}

extension OrderDetailsViewController {
    
    private func addObserver() {
        viewModelNew.responseSubject.subscribe(onNext: {_ in
            self.dismiss(animated: true, completion: nil)
            self.tapDeleteOrder.onNext(())
        })
    }
}
