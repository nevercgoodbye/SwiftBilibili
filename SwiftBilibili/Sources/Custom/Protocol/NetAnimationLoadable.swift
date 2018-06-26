//
//  NetAnimationLoadable.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

private var animationKey: Void?

protocol NetAnimationLoadable {}

extension NetAnimationLoadable where Self: UIViewController {
    
    private var animationType: AnimationType? {
        get { return objc_getAssociatedObject(self, &animationKey) as? AnimationType }
        set { objc_setAssociatedObject(self, &animationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func showAnimationView(_ superView:UIView,animationType:AnimationType = .loading) {
        
        var insert = self
        
        if insert.animationType == animationType { return }
        
        if let existView = superView.subviews.filter({ $0.isKind(of: NetAnimationView.self) }).first as? NetAnimationView {

            existView.removeFromSuperview()
        }
        
        insert.animationType = animationType
        
        let animationView = NetAnimationView(animationType: animationType)
        superView.addSubview(animationView)
        superView.bringSubview(toFront: animationView)
        
        animationView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(220)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(superView).offset(-50*kScreenRatio)
        }
        
        animationView.startAnimation(animationType:animationType)
        
    }
    
    func hideAnimationView(_ superView:UIView) {
        
      guard let animationView = superView.subviews.filter({ $0.isKind(of: NetAnimationView.self) }).first as? NetAnimationView else { return }
        
      var insert = self
        
      animationView.stopAnimation(animationType:insert.animationType!)
      insert.animationType = nil
      animationView.removeFromSuperview()
    }
}
