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
    private var isArticle: Bool = false
    private let maxOffest: CGFloat = isIphoneX ? 88 : 64
    private let minOffest: CGFloat = isIphoneX ? -44 : -32
    private lazy var webView : WKWebView = {
        let webView = WKWebView(frame: .zero)
        return webView
    }()
    private lazy var shadowView : UIImageView = {
        let shadowView = UIImageView(frame: .zero)
        shadowView.image = Image.Home.shadow
        return shadowView
    }()
    
    init(link:String) {
        
        self.link = link
        super.init()
        
        self.isArticle = self.link.contains("cv")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupConstraints() {
        
        if isArticle {
            shadowView.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(maxOffest)
            }
        }
    
        webView.snp.makeConstraints { (make) in
           make.left.right.bottom.equalToSuperview()
           make.top.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(webView)
        if isArticle {
            view.addSubview(shadowView)
        }
        setupWebView()
        
        if self.isArticle {
            adjustScrollViewTop()
            loadProgress()
            navBarConfigure()
        }
    }

    private func setupWebView() {
    
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.delegate = self
        
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
    
    private func loadProgress() {
        
        webView.rx.observe(Double.self, "estimatedProgress")
            .filterNil()
            .subscribe(onNext: { (_) in
                
            })
            .disposed(by: disposeBag)
    }
    
    private func navBarConfigure() {
        
        navBarBackgroundAlpha = 0
        navBarBarTintColor = .db_white
        navBarTintColor = .db_white
        navBarTitleColor = .db_black
        navBarShadowImageHidden = true
        navBarBackgroundImage = Image.Home.shadow
        statusBarStyle = .default
    }
    
}

extension BilibiliWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        if !self.isArticle {
           self.setLeftItems()
           self.setRightItems()
           title = webView.title
        }else{
            webView.evaluateJavaScript("document.getElementsByClassName(\"top-holder\")[0].hidden = true;", completionHandler: nil)
        }
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

extension BilibiliWebViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !self.isArticle { return }
        
        let offestY = scrollView.contentOffset.y
        
        if offestY > 0 {
            let alpha = offestY/maxOffest
            navBarBackgroundAlpha = alpha
            navBarTintColor = UIColor.db_pink.withAlphaComponent(alpha)
            navBarTitleColor = UIColor.db_black.withAlphaComponent(alpha)
            statusBarStyle = .default
            navBarShadowImageHidden = false
            title = webView.title
        }else  {
            
            if offestY < minOffest {
               navBarTintColor = UIColor.db_pink
               statusBarStyle = .default
            }else{
                navBarBackgroundAlpha = 0
                navBarTintColor = .db_white
                navBarTitleColor = .db_white
                statusBarStyle = .lightContent
                navBarShadowImageHidden = true
                title = ""
            }
        }
    }
}

//MARK: - setBarButtonItem
extension BilibiliWebViewController {
    
    private func setLeftItems() {
        let backItem = UIBarButtonItem(image: Image.Home.back, style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        
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
       
       let moreItem = UIBarButtonItem(image: Image.Home.more, style: UIBarButtonItemStyle.plain, target: self, action: #selector(more))
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
