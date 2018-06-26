//
//  UIBarButtonItem+Init.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/9.
//  Copyright © 2018年 罗文. All rights reserved.
//

import Foundation

import UIKit

extension UIBarButtonItem {
    convenience init(title: String?,
                     titleColor: UIColor = .white,
                     titleFont: UIFont = UIFont.systemFont(ofSize: 15),
                     titleEdgeInsets: UIEdgeInsets = .zero,
                     target: Any?,
                     action: Selector?) {
        
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = titleFont
        button.titleEdgeInsets = titleEdgeInsets
        if action != nil {
            button.addTarget(target, action: action!, for: .touchUpInside)
        }
        button.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
//        button.sizeToFit()
//        if button.bounds.width < 40 || button.bounds.height > 40 {
//            let width = 40 / button.bounds.height * button.bounds.width;
//            button.bounds = CGRect(x: 0, y: 0, width: width, height: 40)
//        }
        self.init(customView: button)
    }
    
    convenience init(image: UIImage?,
                     selectImage: UIImage? = nil,
                     imageEdgeInsets: UIEdgeInsets = .zero,
                     target: Any?,
                     action: Selector?) {
        
        let button = UIButton(type: .custom)
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(selectImage?.withRenderingMode(.alwaysOriginal), for: .selected)
        button.imageEdgeInsets = imageEdgeInsets
        if action != nil {
            button.addTarget(target, action: action!, for: .touchUpInside)
        }
        button.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
//        if button.bounds.width < 40 || button.bounds.height > 40 {
//            let width = 40 / button.bounds.height * button.bounds.width;
//            button.bounds = CGRect(x: 0, y: 0, width: width, height: 40)
//        }
        
        self.init(customView: button)
    }
    
}
