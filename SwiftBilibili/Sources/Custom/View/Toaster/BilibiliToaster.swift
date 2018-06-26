//
//  BilibiliToaster.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/21.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import Toaster

final class BilibiliToaster {

   static func show(_ text: String,
                    _ delay: TimeInterval = 0,
                    _ duration: TimeInterval = 3,
                    bottomOffsetPortrait: CGFloat = kToastBottomMaxSpace) {
    
        ToastView.appearance().bottomOffsetPortrait = bottomOffsetPortrait
    
        Toast(text: text, delay: delay, duration: duration).show()
    }
   
    
    

}
