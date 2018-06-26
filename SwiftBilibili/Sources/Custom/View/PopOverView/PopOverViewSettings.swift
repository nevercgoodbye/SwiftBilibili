//
//  PopOverViewSettings.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/24.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

struct PopOverViewSettings {

    struct Behavior {
        
        /** 点击是否隐藏  默认是true **/
        var hideOnTap = true
        /** 是否允许滚动 默认是false  **/
        var scrollEnable = false
        /** 是否具有弹性  默认是false **/
        var bounces = false
    }
    
    struct ArrowViewStyle {
        /** 边缘是否对齐  默认是false **/
        var edgeAlignment = false
    
        var height = CGFloat(15.0)
        
        var width = CGFloat(22.0)
        /** 箭头距离目标的偏移  默认是5.0 **/
        var targetOffest = CGFloat(5.0)
        
        var igoreOffest = CGFloat(44)
        
        var upOffest = CGFloat(170)
        
        var arrowCornerRadius = CGFloat(0)
        
        var arrowBottomCornerRadius = CGFloat(4.0)
    }

    struct OverViewStyle {
        
        var coverViewColor = UIColor.black.withAlphaComponent(0.05)
        
        var backgroundColor = UIColor.white
        
        var horizontalMargin = CGFloat(10.0)
        
        var verticalMargin = CGFloat(30.0)
        
        var viewCornerRadius = CGFloat(6.0)
        
        var viewWidth = CGFloat(150.0)
    }
    
    struct AnimationStyle {
        
        var scale: CGSize = CGSize(width: 0.01, height: 0.01)
        
        var duration = TimeInterval(0.25)
        
        var tapShouldAnimated = false
        
    }
    
    var behavior = Behavior()
    var arrowView = ArrowViewStyle()
    var overView = OverViewStyle()
    var animation = AnimationStyle()
    
    static func defaultSettings() -> PopOverViewSettings {
        
       return PopOverViewSettings()
        
    }
}
