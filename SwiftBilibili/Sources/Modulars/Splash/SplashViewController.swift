//
//  SplashViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class SplashViewController: BaseViewController {

    private let presentMainScreen: () -> Void
    
    private let backgroundImageView = UIImageView().then{
        $0.image = Image.Launch.background
    }
    
    private let splashImageView = UIImageView().then{
        $0.image = Image.Launch.splash
    }

    override func setupConstraints() {
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        splashImageView.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenWidth - 60)
            make.height.equalTo(kScreenHeight * 0.4)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
    
    init(presentMainScreen: @escaping () -> Void) {
        
        self.presentMainScreen = presentMainScreen
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //View controller-based status bar appearance
        UIApplication.shared.isStatusBarHidden = true
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(splashImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.delay(time: 1.0, action: {[weak self] in
            self?.presentMainScreen()
        })
    }
    
}
