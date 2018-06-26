//
//  Action.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/2.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

struct Action<T> {

    fileprivate(set) var data: T?
    fileprivate(set) var handler: ((Action<T>) -> Void)?
    
    init(_ data: T?,handler: ((Action<T>) -> Void)?) {
        self.data = data
        self.handler = handler
    }
}
