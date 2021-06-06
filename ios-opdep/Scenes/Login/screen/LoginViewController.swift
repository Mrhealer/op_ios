//
//  LoginViewController.swift
//  ios-opdep
//
//  Created by Healer on 29/05/2021.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import ReactiveCocoa
import ReactiveSwift
import SkyFloatingLabelTextField
import AuthenticationServices

class LoginViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var textWellcome: UILabel!
    @IBOutlet weak var textDesAuth: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var appleLoginButton: UIButton!
    
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
        
        if #available(iOS 13.0, *) {
            appleLoginButton.isHidden = false
        } else {
            appleLoginButton.isHidden = true
        }

    }
    
    @IBAction func loginFacebook(_ sender: Any) {
        getFacebookUserInfo()
    }
    
    func getFacebookUserInfo() {
            let loginManager = LoginManager()
            loginManager.logOut()
            loginManager.logIn(permissions: [.email, .publicProfile], viewController: self) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .cancelled:
                    print("Cancel button click")
                case .success( _, _, let token):
                    print("success", token as Any)
                    self.getUserProfile()

                default:
                    print("??")
                }
            }
        }
    
    func getUserProfile() {
               let connection = GraphRequestConnection()
               connection.add(GraphRequest(graphPath: "/me", parameters: ["fields" : "id,name,email"], httpMethod: .get)) { (connection, response, error) in
                   if let error = error {
                       print("Error getting user info = \(error.localizedDescription)")
                   } else {
                       guard let userInfo = response as? Dictionary<String,Any> else {
                           return
                       }
                    let userID = userInfo["id"] as? String ?? ""
                    let userName = userInfo["name"] as? String ?? ""
                    let email = userInfo["email"] as? String ?? ""
                    let dataLogin = DataLogin(name: userName, fb_id: userID, email_google: email, phone_number_firebase: "", type: "1",apple_id: "")
                    self.viewModel.dataLogin.value = dataLogin
                    self.viewModel.loginWithSocial()

                   }
               }
               connection.start()
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
            let userID = user.userID ?? ""
            let userName = user.profile.name ?? ""
            let email = user.profile.email ?? ""
            let dataLogin = DataLogin(name: userName, fb_id: userID, email_google: email, phone_number_firebase: "", type: "3",apple_id: "")
            self.viewModel.dataLogin.value = dataLogin
            self.viewModel.loginWithSocial()
    
        } else {
            return
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        InformationRouter(AppLogic.shared.appRouter.rootNavigationController).close()
    }
    
    @IBAction func taploginApple(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.fullName
            let userId = appleIDCredential.user
            if let data = appleIDCredential.authorizationCode, let _ = String(data: data, encoding: .utf8) {
                let name = "\(userIdentifier?.givenName ?? "")\(userIdentifier?.familyName ?? "")"
                let email = appleIDCredential.email ?? ""
                let dataLogin = DataLogin(name: name, fb_id: "", email_google: email, phone_number_firebase: "", type: "5", apple_id: userId)
                self.viewModel.dataLogin.value = dataLogin
                self.viewModel.loginWithSocial()
            }
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        switch error.code {
        case .canceled:
            print("Canceled")
        case .unknown:
            print("Unknown")
        case .invalidResponse:
            print("Invalid Respone")
        case .notHandled:
            print("Not handled")
        case .failed:
            print("Failed")
        @unknown default:
            print("Default")
        }
    }
    
}
