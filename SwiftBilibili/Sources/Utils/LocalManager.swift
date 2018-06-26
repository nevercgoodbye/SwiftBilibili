//
//  LocalManager.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/23.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import SwiftyUserDefaults

class LocalManager {
    
    struct UserInfo {
        var isLogin: Bool {
            set{
               Defaults[.isLogin] = newValue
            }
            get{
               return Defaults[.isLogin]
            }
        }
        
        var openTimes: Int {
            set{
                Defaults[.openTimes] = newValue
            }
            get{
                return Defaults[.openTimes]
            }
        }
        
        var avater: UIImage? {
            set{
                if newValue != nil {
                    Defaults[.avater] = UIImagePNGRepresentation(newValue!) ?? Data()
                }
            }
            get{
                return UIImage(data: Defaults[.avater])
            }
        }
        //还有昵称等等
    }
    
    static var userInfo: UserInfo = UserInfo()
    
}
