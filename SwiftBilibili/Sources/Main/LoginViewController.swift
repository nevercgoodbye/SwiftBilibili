//
//  LoginViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/21.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class LoginViewController: BaseViewController {

    let loginButton = UIButton().then{
        $0.setTitle("登录", for: .normal)
        $0.setTitleColor(UIColor.db_black, for: .normal)
    }
    
    override func setupConstraints() {
        loginButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "登录"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        
        self.view.addSubview(loginButton)
        
        
        loginButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
            
            //模拟登录网络延迟
            DispatchQueue.delay(time: 0.25, action: {
                LocalManager.userInfo.isLogin = true
                self.back(true)
            })
        }).disposed(by: disposeBag)
        
    }

    @objc private func back(_ animated:Bool = false) {
        
        self.dismiss(animated: false, completion: nil)
    }

}
