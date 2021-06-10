//
//  TemplateController.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 6/3/21.
//

import UIKit

class TemplateController: BasicViewController {

    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var tableView: UITableView!
    override var shouldHideNavigationBar: Bool { true }
    let viewModel: TemplateViewModel
    
    var tappedCell: Content!
    
    
    init(viewModel: TemplateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TemplateController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        bindViewModel(viewModel)
        viewModel.fetchTemplate()
        viewModel.fetchTemplateAction.values.observeValues { _ in
            self.tableView.reloadData()
        }
        
        tableView.separatorStyle = .none
        
        // Register the xib for tableview cell
        let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "tableviewcellid")
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    
}

extension TemplateController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.templateData.value.count - 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // Category Title
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.init(hexString: "#FFB0BD")
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 0, width: 200, height: 44))
        headerView.addSubview(titleLabel)
        titleLabel.textColor = .blue
        titleLabel.font = R.font.openSansBold(size: 18)
        titleLabel.text = viewModel.templateData.value[section].name
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewcellid", for: indexPath) as? TableViewCell {
            // Show SubCategory Title
//            let subCategoryTitle = viewModel.templateData.value
//            cell.subCategoryLabel.text = subCategoryTitle[indexPath.section].name
            // Pass the data to colletionview inside the tableviewcell
            let rowArray = viewModel.templateData.value[indexPath.section].content
            
            
            cell.updateCellWith(row: rowArray)

            // Set cell's delegate
            cell.cellDelegate = self
            
            cell.selectionStyle = .none
            return cell
       }
        return UITableViewCell()
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "detailsviewcontrollerseg" {
////            let DestViewController = segue.destination as! DetailsViewController
////            DestViewController.backgroundColor = tappedCell.color
////            DestViewController.backgroundColorName = tappedCell.name
//        }
//    }
}

extension TemplateController: CollectionViewCellDelegate {
    func collectionView(collectionviewcell: CollectionViewCell?, index: Int, didTappedInTableViewCell: TableViewCell) {
        if let colorsRow = didTappedInTableViewCell.rowWithColors {
            self.tappedCell = colorsRow[index]
            
            let vc = TemplateDetailViewController(viewModel: viewModel)
            vc.tappedCell = self.tappedCell
            self.navigationController?.pushViewController(vc, animated: true)
//            performSegue(withIdentifier: "detailsviewcontrollerseg", sender: self)
            // You can also do changes to the cell you tapped using the 'collectionviewcell'
        }
    }
}

