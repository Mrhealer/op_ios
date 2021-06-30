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
    @IBOutlet weak var deleteOrder: UIButton!
    @IBOutlet weak var itemStackView: UIStackView!
    
    var data: OrderHistoryResponse
    var tapDeleteOrder = PublishSubject<Void>()
    let viewModelNew = OrderViewModel()
    
    init(order: OrderHistoryResponse) {
        data = order
        super.init(nibName: "OrderDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        addObserver()
    }
    
    func loadData() {
        titleHeader.text = "Đơn hàng"
        codeLabel.text = "Mã \(data.id ?? 0)"
        status.text = data.statusText
        timeOrderLabel.text = "Ngày đặt hàng: \(data.createdAt ?? "")"
        prince.text = "Thành tiền: \(UtilityPrice.formatCurrency(currencyString: data.totalPrice ?? ""))"
        addressLabel.text = "\(data.customerAddress ?? "")\n\(data.city ?? "")\n\(data.country ?? "")"
        
        data.details?.forEach({ (order) in
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.black.cgColor
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            imageView.snp.makeConstraints({
                $0.top.leading.equalToSuperview().offset(10)
                $0.bottom.equalToSuperview().offset(-10)
                $0.width.height.equalTo(80)
            })
            imageView.sd_setImage(with: URL(string: order.fullPhotoUrl ?? ""), completed: nil)
            let priceLabel = UILabel()
            priceLabel.translatesAutoresizingMaskIntoConstraints = false
            priceLabel.text = UtilityPrice.formatCurrency(currencyString: order.order?.totalPrice ?? "")
            priceLabel.font = R.font.openSansBold(size: 17)
            priceLabel.textColor = UIColor(hexString: "#DC8AFF")
            view.addSubview(priceLabel)
            priceLabel.snp.makeConstraints({
                $0.leading.equalTo(imageView.snp.trailing).offset(30)
                $0.centerY.equalTo(imageView.snp.centerY)
            })
            itemStackView.addArrangedSubview(view)
        })
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapCancelOrder(_ sender: Any) {
        viewModelNew.cancelOrder(orderId: "\(data.id ?? 0)")
    }
    
}

extension OrderDetailsViewController {
    
    private func addObserver() {
        viewModelNew.responseSubject.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
            self?.tapDeleteOrder.onNext(())
        })
    }
}
