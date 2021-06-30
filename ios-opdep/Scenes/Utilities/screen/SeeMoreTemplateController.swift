//
//  SeeMoreTemplateController.swift
//  ios-opdep
//
//  Created by VMO on 6/30/21.
//

import UIKit

class SeeMoreTemplateController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel: TemplateViewModel
    let template: Template
    
    init(viewModel: TemplateViewModel, template: Template) {
        self.viewModel = viewModel
        self.template = template
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

        titleLabel.text = template.name
        
        // Register the xib for tableview cell
        let cellNib = UINib(nibName: "TemplateCollectionCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "collectionviewcellid")
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SeeMoreTemplateController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = template.content[indexPath.item]
        if content.category != nil {
            let vc = TemplateDetailViewController(viewModel: viewModel)
            vc.tappedCell = content
            navigationController?.pushViewController(vc, animated: true)
        } else if let contentTemplate = content.template {
            let template = TemplateCategoryData(contentTemplate: contentTemplate)
            let vc = SelectPhoneViewController(viewModel: viewModel, template: template)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension SeeMoreTemplateController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return template.content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionviewcellid", for: indexPath) as? TemplateCollectionCell else {
            return UICollectionViewCell()
        }
        
        let content = template.content[indexPath.item]
        if content.category != nil {
            let urlString = content.category?.imageURL ?? ""
            if let url = URL(string: urlString) {
                cell.templateImageView.sd_setImage(with: url, completed: nil)
            }
        } else {
            let urlString = content.template?.imageURL ?? ""
            if let url = URL(string: urlString) {
                cell.templateImageView.sd_setImage(with: url, completed: nil)
            }
        }
        
        return cell
    }
    
}

extension SeeMoreTemplateController: UICollectionViewDelegateFlowLayout {

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
