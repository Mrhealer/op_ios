//
//  WebViewController.swift
//  ios-opdep
//
//  Created by Healer on 30/05/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var natigatorBar: UINavigationBar!
    @IBOutlet weak var webViewController:WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Localize.InfomationAccount.term
        self.navigationController?.navigationBar.barTintColor = UIColor.Basic.ping
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = false

        
        let myUrl = Bundle.main.path(forResource: "terms_conditions_en", ofType: "html")
        let html = try? String(contentsOfFile: myUrl!, encoding: String.Encoding.utf8)
        webViewController.loadHTMLString(html!, baseURL: nil)
        
    }
    
   
}
