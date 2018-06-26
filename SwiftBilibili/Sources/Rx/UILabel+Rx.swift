//
//  UILabel+Rx.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/6.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {
    
    var textColor: Binder<UIColor?> {
        return Binder(self.base) { view,color in
            view.textColor = color ?? .clear
        }
    }
}
