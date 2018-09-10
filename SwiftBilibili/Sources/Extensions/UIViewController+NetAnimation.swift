//
//  UIViewController+NetAnimation.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/9/4.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showLoadingAnimation(superView: UIView) {
        
        if let existView = superView.subviews.filter({ $0.isKind(of: NetAnimationView.self) }).first as? NetAnimationView {
            existView.removeFromSuperview()
        }
        
        let animationView = NetAnimationView(animationType: .loading)
        superView.addSubview(animationView)
        superView.bringSubview(toFront: animationView)
        
        animationView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(220)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        animationView.startAnimation(animationType:.loading)
    }
    
    func hideLoadingAnimation(superView: UIView) {
        
        guard let animationView = superView.subviews.filter({ $0.isKind(of: NetAnimationView.self) }).first as? NetAnimationView else { return }
        
        animationView.stopAnimation(animationType:.loading)
        animationView.removeFromSuperview()
    }
    
}
