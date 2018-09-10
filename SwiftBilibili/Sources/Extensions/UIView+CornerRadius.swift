//
//  UIView+CornerRadius.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/17.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
    
    func setShadow(shadowOpacity:Float = 0.1,
                   shadowRadius:CGFloat = kCornerRadius,
                   shadowOffset:CGSize = .zero,
                   shadowColor:CGColor = UIColor.db_black.cgColor
         ) {
        
        layer.masksToBounds = false
        layer.contentsScale = UIScreen.main.scale
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: shadowRadius).cgPath
        //设置缓存
        layer.shouldRasterize = true
        //设置抗锯齿边缘
        layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    func clipRectCorner(direction: UIRectCorner,cornerRadius: CGFloat) {
        
        let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
        
    }
    
}
