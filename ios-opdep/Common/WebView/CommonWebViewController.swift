//
//  CommonWebViewController.swift

import Foundation
import WebKit

class CommonWebViewController: BasicViewController {
    override var navigationStyle: NavigationStyle { .secondary }
    private let viewModel: CommonWebViewViewModel
    private let webView = WKWebView()
    private let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.Basic.primary
        prepare()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.Basic.secondary,
            .font: UIFont.font(style: .bold,
                               size: 14)
        ]
        loadLink()
    }
    
    init(viewModel: CommonWebViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        view.addSubviews(webView,
                         activityView)
        webView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(1)
        }
        activityView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
    }
    
    func loadLink() {
        guard let url = URL(string: viewModel.link) else { return }
        activityView.startAnimating()
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension CommonWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityView.stopAnimating()
    }
}
