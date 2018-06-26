//
//  NotificationCenter+Rx.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/21.
//  Copyright © 2018年 罗文. All rights reserved.
//

import RxSwift

enum BiliNotification: String {
    
    case netError
    case stopRotate
    case startRequest
    case endRequest
    
    var stringValue: String {
        
        return "Bilibili" + rawValue
    }
    
    var notificationName: NSNotification.Name {
        
        return NSNotification.Name(stringValue)
    }
}

extension NotificationCenter {
    
   static func post(customNotification name: BiliNotification,object: Any? = nil) {
        
        NotificationCenter.default.post(name: name.notificationName, object: object)
    }
    
}

extension Reactive where Base: NotificationCenter {
    
    func notification(custom name: BiliNotification,object: AnyObject? = nil) -> Observable<Notification>
    {
        
        return notification(name.notificationName, object: object)
        
    }
}
