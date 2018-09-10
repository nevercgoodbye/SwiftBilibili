//
//  BilibiliArticleViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/6/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import WebKit

final class BilibiliArticleViewController: BaseViewController {

    private var link: String
    private let maxOffest: CGFloat = isIphoneX ? 88 : 64
    private let minOffest: CGFloat = isIphoneX ? 44 : 32
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.scrollView.backgroundColor = UIColor.db_gray
        return webView
    }()
    private lazy var navBar: BilibiliArticleNavBar = {
        let navBar = BilibiliArticleNavBar.loadFromNib()
        navBar.backgroundColor = UIColor.db_white
        navBar.alpha = 0
        navBar.backButton.setImage(Image.Home.back?.with(color: UIColor.db_pink), for: .normal)
        navBar.shareButton.setImage(Image.Article.more?.with(color: UIColor.db_pink), for: .normal)
        navBar.applyButton.setImage(Image.Home.editRcmd?.with(color: UIColor.db_pink), for: .normal)
        
        return navBar
    }()
    private lazy var backButton: UIButton = {
        let backButton = UIButton(frame: .zero)
        backButton.setImage(Image.Home.back, for: .normal)
        return backButton
    }()
    private lazy var shareButton: UIButton = {
        let shareButton = UIButton(frame: .zero)
        shareButton.setImage(Image.Article.more?.with(color: UIColor.db_white), for: .normal)
        return shareButton
    }()
    
    
    init(link:String) {
        
        self.link = link
        super.init()
        
        log.info(link)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupConstraints() {
        
        webView.snp.makeConstraints { (make) in
           make.edges.equalToSuperview()
        }
        
        navBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(maxOffest)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.left.equalTo(15)
            make.centerY.equalTo(navBar.snp.centerY).offset(20)
        }
        shareButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.right.equalTo(-15)
            make.centerY.equalTo(navBar.snp.centerY).offset(20)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(webView)
        self.view.addSubview(navBar)
        self.view.addSubview(backButton)
        self.view.addSubview(shareButton)
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.delegate = self
        
        if #available(iOS 11, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if let linkURL = URL(string: link) {
            webView.load(URLRequest(url: linkURL))
        }
        
        self.clickEvent()
        
    }
    
    private func loadProgress() {

        webView.rx.observe(Double.self, "estimatedProgress")
            .filterNil()
            .subscribe(onNext: { (_) in

            })
            .disposed(by: disposeBag)
    }
    
    private func clickEvent() {
        
        navBar.backButton.rx.tap
            .subscribe(onNext: {[unowned self] (_) in
            
              self.navigationController?.popViewController(animated: true)
          })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .subscribe(onNext: {[unowned self] (_) in
                
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension BilibiliArticleViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        
        webView.evaluateJavaScript("document.getElementsByClassName(\"top-holder\")[0].hidden = true;", completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }
}

extension BilibiliArticleViewController: UIScrollViewDelegate {
    
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
            let offestY = scrollView.contentOffset.y
            if offestY > 0 {
                backButton.alpha = 0
                shareButton.alpha = 0
                let alpha = (offestY+minOffest)/maxOffest
                navBar.alpha = alpha
                navBar.titleLabel.text = webView.title

            }else  {
               backButton.alpha = 1
               shareButton.alpha = 1
               navBar.alpha = 0
            }
        }
}

