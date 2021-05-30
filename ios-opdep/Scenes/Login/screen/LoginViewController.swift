//
//  LoginViewController.swift
//  ios-opdep
//
//  Created by Healer on 29/05/2021.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var textWellcome: UILabel!
    @IBOutlet weak var textDesAuth: UILabel!
    @IBOutlet weak var viewGoogle: UIView!
    @IBOutlet weak var viewFacebook: UIView!
    let viewModel: LoginViewModel
    
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Localize.InfomationAccount.auth
        self.navigationController?.navigationBar.barTintColor = UIColor.Basic.ping
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        let backButton = UIBarButtonItem()
        backButton.title = "New Back Button Text"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        
        textWellcome.text = Localize.Login.title
        textDesAuth.text = Localize.Login.description
        textWellcome.font = R.font.openSansBold(size: 16)
        textWellcome.textAlignment = .center
        textDesAuth.font = R.font.openSansSemiBold(size: 14)
        textDesAuth.textAlignment = .center
        
        viewGoogle.backgroundColor = .red
        viewFacebook.backgroundColor = .blue
    }
    
    
    
}
