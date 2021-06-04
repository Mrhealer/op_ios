//
//  TemplateDetailViewController.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 6/4/21.
//

import UIKit

class TemplateDetailViewController: BasicViewController {

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
        
    }

}
