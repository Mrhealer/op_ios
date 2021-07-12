//
//  SelectPhoneViewController.swift
//  ios-opdep
//
//  Created by VMO on 6/9/21.
//

import UIKit

class SelectPhoneViewController: UIViewController {
    
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var templateImageView: UIImageView!
    @IBOutlet weak var phoneBrandTableView: UITableView!
    @IBOutlet weak var phoneNameTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    let viewModel: TemplateViewModel
    let template: TemplateCategoryData
    
    var selectBrandIndex = 0
    var selectNameIndex: Int?
    
    init(viewModel: TemplateViewModel, template: TemplateCategoryData) {
        self.viewModel = viewModel
        self.template = template
        super.init(nibName: "SelectPhoneViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: template.imageURL) {
            templateImageView.sd_setImage(with: url, completed: nil)
        }

        viewModel.fetchPhoneTemplate()
        viewModel.fetchPhoneTemplateAction.values.observeValues { _ in
            self.phoneBrandTableView.reloadData()
            self.viewModel.fetchPhoneList(categoryId: "\(self.viewModel.phoneTemplateData.value.first?.id ?? 0)")
        }
        
        viewModel.fetchPhoneListAction.values.observeValues { _ in
            self.phoneNameTableView.reloadData()
        }
        
        let cellNib = UINib(nibName: "PhoneTableViewCell", bundle: nil)
        self.phoneBrandTableView.register(cellNib, forCellReuseIdentifier: "tableviewcellid")
        self.phoneNameTableView.register(cellNib, forCellReuseIdentifier: "tableviewcellid")
        
        nextButton.backgroundColor = UIColor(hexString: "#AEAEB2")
    }
    
    @IBAction func onPressEdit(_ sender: Any) {
        guard let selectNameIndex = selectNameIndex else {
            return
        }
        let vc = EditPhoneViewController(viewModel: viewModel, template: template, phoneImageData: viewModel.phoneListData.value[selectNameIndex])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SelectPhoneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case phoneBrandTableView:
            selectBrandIndex = indexPath.row
            selectNameIndex = nil
            self.viewModel.fetchPhoneList(categoryId: "\(self.viewModel.phoneTemplateData.value[selectBrandIndex].id)")
            phoneBrandTableView.reloadData()
            nextButton.backgroundColor = UIColor(hexString: "#AEAEB2")
        case phoneNameTableView:
            selectNameIndex = indexPath.row
            phoneNameTableView.reloadData()
            if let url = URL(string: viewModel.phoneListData.value[indexPath.row].editor[1].image ?? "") {
                phoneImageView.sd_setImage(with: url, completed: nil)
            }
            nextButton.backgroundColor = UIColor(hexString: "#00ACEA")
        default:
            fatalError()
        }
    }
}

extension SelectPhoneViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case phoneBrandTableView:
            return viewModel.phoneTemplateData.value.count - 1
        case phoneNameTableView:
            return viewModel.phoneListData.value.count - 1
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewcellid", for: indexPath) as? PhoneTableViewCell else {
            return UITableViewCell()
        }
        switch tableView {
        case phoneBrandTableView:
            cell.nameLabel.text = viewModel.phoneTemplateData.value[indexPath.row].name
            cell.selectImageView.isHidden = selectBrandIndex != indexPath.row
        case phoneNameTableView:
            cell.nameLabel.text = viewModel.phoneListData.value[indexPath.row].name
            if let selectNameIndex = self.selectNameIndex {
                cell.selectImageView.isHidden = selectNameIndex != indexPath.row
            } else {
                cell.selectImageView.isHidden = true
            }
        default:
            fatalError()
        }
        return cell
    }
    
    
}
