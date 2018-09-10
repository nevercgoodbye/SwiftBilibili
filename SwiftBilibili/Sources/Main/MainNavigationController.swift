//
//  MainNavigationController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/14.
//  Copyright © 2018年 罗文. All rights reserved.
//
import UIKit

import RxSwift

final class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
        
        self.navigationBar.setBackgroundImage(UIImage.size(CGSize(width: 1, height: 1)).color(UIColor.db_pink).image, for: .default)
        
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.db_white]
       
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool){
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let backItem = UIBarButtonItem(image: Image.Home.back?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
            viewController.navigationItem.leftBarButtonItems = [backItem]
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func back() {
        
        self.popViewController(animated: true)
        
    }
}

extension MainNavigationController: UIGestureRecognizerDelegate {}
