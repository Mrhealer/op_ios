//
//  LoginViewController.swift
//  ios-opdep
//
//  Created by Healer on 29/05/2021.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var textWellcome: UILabel!
    @IBOutlet weak var textDesAuth: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleHeader: UILabel!
    
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
        titleHeader.text = Localize.InfomationAccount.auth
        
        textWellcome.text = Localize.Login.title
        textDesAuth.text = Localize.Login.description
        textWellcome.font = R.font.openSansBold(size: 16)
        textWellcome.textAlignment = .center
        textDesAuth.font = R.font.openSansSemiBold(size: 14)
        textDesAuth.textAlignment = .center
    }
    
    @IBAction func loginFacebook(_ sender: Any) {
        getFacebookUserInfo()
    }
    
    func getFacebookUserInfo() {
            let loginManager = LoginManager()
            loginManager.logOut()
            loginManager.logIn(permissions: [.email, .publicProfile], viewController: self) { [weak self] (result) in
                guard self != nil else { return }
                switch result {
                case .cancelled:
                    print("Cancel button click")
                case .success( _, _, let token):
                    print("success", token as Any)
                default:
                    print("??")
                }
            }
        }
    
    @IBAction func signinGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            return
        }
        if let idtoken = user.authentication.idToken {
            print("abc123===", idtoken)
        } else {
            return
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        InformationRouter(AppLogic.shared.appRouter.rootNavigationController).close()
    }
    
}
