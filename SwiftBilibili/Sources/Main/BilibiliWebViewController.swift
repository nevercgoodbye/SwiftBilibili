//
//  BilibiliWebViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/8.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import WebKit
import RxSwift

final class BilibiliWebViewController: BaseViewController {

    private var link: String

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        return webView
    }()
    
    init(link:String) {
        
        self.link = link
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupConstraints() {
        
        webView.snp.makeConstraints { (make) in
           make.edges.equalToSuperview()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(webView)
        
        setupWebView()
        
    }

    private func setupWebView() {
    
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        if let linkURL = URL(string: link) {
            webView.load(URLRequest(url: linkURL))
           
        }
    }
    
    private func adjustScrollViewTop() {
        if #available(iOS 11, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    

    
}

extension BilibiliWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        self.setLeftItems()
        self.setRightItems()
        title = webView.title
            //webView.evaluateJavaScript("document.getElementsByClassName(\"top-holder\")[0].hidden = true;", completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        BilibiliToaster.show("被禁止访问了???")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }

}

//MARK: - setBarButtonItem
extension BilibiliWebViewController {
    
    private func setLeftItems() {
        let backItem = UIBarButtonItem(image: Image.Home.back?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        
        let closeButton = UIButton(type: .custom)
        closeButton.setTitle("关闭", for: UIControlState.normal)
        closeButton.setTitleColor(UIColor.db_white, for: UIControlState.normal)
        closeButton.titleLabel?.font = Font.SysFont.sys_16
        closeButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            self.close()
        }).disposed(by: disposeBag)
        let closeItem = UIBarButtonItem(customView: closeButton)
        
        self.navigationItem.leftBarButtonItems = [backItem,closeItem]
    }
    
    private func setRightItems() {
       
       let moreImage = Image.Home.more?.with(color: UIColor.db_white)
        
        let moreItem = UIBarButtonItem(image:moreImage?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(more))
       self.navigationItem.rightBarButtonItem = moreItem
    }
    
    @objc private func back() {
        
        if webView.canGoBack {
            webView.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func more() {
       
    }
}
