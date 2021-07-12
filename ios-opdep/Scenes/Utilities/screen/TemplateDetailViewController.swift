//
//  TemplateDetailViewController.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 6/4/21.
//

import UIKit

class TemplateDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override var shouldHideNavigationBar: Bool { true }
    let viewModel: TemplateViewModel
    
    var tappedCell: Content!
    
    
    init(viewModel: TemplateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TemplateDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        bindViewModel(viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = tappedCell.category?.name
        
        let id = tappedCell.category?.id ?? 0
        viewModel.fetchTemplateCategory(categoryId: "\(id)")
        viewModel.fetchTemplateCategoryAction.values.observeValues { _ in
            self.collectionView.reloadData()
        }
        
        // Register the xib for tableview cell
        let cellNib = UINib(nibName: "TemplateCollectionCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "collectionviewcellid")
    }

    @IBAction func onPressBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension TemplateDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SelectPhoneViewController(viewModel: viewModel, template: viewModel.templateCategoryData.value[indexPath.item])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TemplateDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.templateCategoryData.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionviewcellid", for: indexPath) as? TemplateCollectionCell else {
            return UICollectionViewCell()
        }
        
        
        if let url = URL(string: viewModel.templateCategoryData.value[indexPath.item].imageURL) {
            cell.templateImageView.sd_setImage(with: url, completed: nil)
 
        }
        return cell
    }
    
}

extension TemplateDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        return CGSize(width: width, height: width * 1.9)
    }
    
}
