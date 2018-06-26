//
//  UIView+Rx.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/1.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIView {
    var setNeedsLayout: Binder<Void> {
        return Binder(self.base) { view, _ in
            view.setNeedsLayout()
        }
    }
    
    var backgroundColor: Binder<UIColor?> {
        return Binder(self.base) { view,color in
            view.backgroundColor = color
        }
    }
    
    var borderColor: Binder<UIColor?> {
        return Binder(self.base) { view,color in
            view.borderColor = color ?? .clear
        }
    }
}
