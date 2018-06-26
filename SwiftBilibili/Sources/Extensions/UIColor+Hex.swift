//
//  UIColor+Hex.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/14.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

extension UIColor {
    
    //在extension中给系统的类扩充构造函数,只能扩充`便利构造函数`
    convenience init(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ alpha:CGFloat = 1.0) {
        
        self.init(red:r/255.0,green:g/255.0,blue:b/255.0,alpha:alpha)
        
    }
    
    convenience init?(_ hex : String, _ alpha : CGFloat = 1.0) {
        
        // 0xff0000
        // 1.判断字符串的长度是否符合
        guard hex.count >= 6 else {
            return nil
        }
        
        // 2.将字符串转成大写
        var tempHex = hex.uppercased()
        
        // 3.判断开头: 0x/#/##
        if tempHex.hasPrefix("0x") || tempHex.hasPrefix("##") {
            tempHex = (tempHex as NSString).substring(from: 2)
        }
        if tempHex.hasPrefix("#") {
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        
        // 4.分别取出RGB
        // FF --> 255
        var range = NSRange(location: 0, length: 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        
        // 5.将十六进制转成数字 emoji表情
        var r : UInt32 = 0, g : UInt32 = 0, b : UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(CGFloat(r), CGFloat(g), CGFloat(b))
    }
    
    class func randomColor() -> UIColor {
        return UIColor(CGFloat(arc4random_uniform(256)),CGFloat(arc4random_uniform(256)),CGFloat(arc4random_uniform(256)))
    }
    
    
}
