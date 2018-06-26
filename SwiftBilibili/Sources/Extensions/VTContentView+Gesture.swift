//
//  VTContentView+Gesture.swift
//  LWBilibili
//
//  Created by 罗文 on 17/5/11.
//  Copyright © 2017年 wenhua. All rights reserved.
//

import VTMagic

//允许边缘侧滑返回
extension VTContentView:UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return gestureRecognizer is UIPanGestureRecognizer
            && otherGestureRecognizer is UIScreenEdgePanGestureRecognizer
        
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return gestureRecognizer is UIPanGestureRecognizer
            && otherGestureRecognizer is UIScreenEdgePanGestureRecognizer
    }
    
    
}
