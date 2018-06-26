//
//  ProcessTimeManager.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/5.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import SwiftDate

func dispatch_async_safely_to_main_queue(_ block: @escaping ()->()) {
    dispatch_async_safely_to_queue(DispatchQueue.main, block)
}

// This methd will dispatch the `block` to a specified `queue`.
// If the `queue` is the main queue, and current thread is main thread, the block
// will be invoked immediately instead of being dispatched.
func dispatch_async_safely_to_queue(_ queue: DispatchQueue, _ block: @escaping ()->()) {
    if queue === DispatchQueue.main && Thread.isMainThread {
        block()
    } else {
        queue.async {
            block()
        }
    }
}

enum TimeFormatStyle: String {
    case `default` = "yyyy-MM-dd HH:mm:ss"
}


final class ProcessTimeManager {
    
   class func overSetTime(referenceDate:Date?,compareDate:Date?,targetMinute:Int) -> Bool {
        
        guard let referenceDate = referenceDate,
              let compareDate = compareDate
        else { return false }
        
        let referenceRome = DateInRegion(absoluteDate: referenceDate)
        
        let compareRome = DateInRegion(absoluteDate: compareDate)
        
        let minute = compareRome.minute - referenceRome.minute
        
        return minute > targetMinute
    }
    
}
