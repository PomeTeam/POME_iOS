//
//  OpenSourceLicenseViewController.swift
//  POME
//
//  Created by gomin on 2023/03/04.
//

import Foundation
import UIKit
import WebKit

class OpenSourceLicenseViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    var webView: WKWebView!

    override func loadView() {
       super.loadView()
       
       setUpLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let localFilePath = Bundle.main.path(forResource: "pome_ios_opensource", ofType: "html")
            else {
                print("path is nil")
                return
                }

        let url = URL(fileURLWithPath: localFilePath)
        let request = URLRequest(url: url)
        webView.load(request as URLRequest)
    }

    func setUpLayout() {
        webView = WKWebView()
        self.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }

    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage
       message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping() -> Void) {
    }

    // Web View에서 웹 컨텐츠를 받기 시작할 때 호출
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

    }

    // 웹 컨텐츠가 Web View로 로드되기 시작할 때 호출
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }

    @available(iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

    }
}
