//
//  UIScrollView+Direction.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/6/21.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit
import RxSwift

enum ScrollDirection {
    case none
    case down
    case up
}

extension UIScrollView {
    
    private struct AssociatedKeys {
        static var scrollDirection = "scrollDirection"
        static var enableDirection = "enableDirection"
    }
    
    
    var scrollDirection: ScrollDirection {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.scrollDirection) as? ScrollDirection ?? .none
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.scrollDirection, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var enableDirection: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.enableDirection) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.enableDirection, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if enableDirection {
               self.addObserver(self, forKeyPath: "contentOffest", options: [.old,.new], context: nil)
            }
        }
        
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentOffest" {
            let newOffest = change?[NSKeyValueChangeKey.newKey] as? CGPoint ?? .zero
            let oldOffest = change?[NSKeyValueChangeKey.oldKey] as? CGPoint ?? .zero
            
            if newOffest.y > oldOffest.y {
                self.scrollDirection = .up
            }else if newOffest.y < oldOffest.y {
                self.scrollDirection = .down
            }
        }
        

    }
}


