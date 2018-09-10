//
//  UIScrollView+Rx.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIScrollView {
    
    var isReachedBottom: ControlEvent<Void> {
        let source = self.contentOffset
            .filter { [weak base = self.base] offset in
                guard let base = base else { return false }
                return base.isReachedBottom(withTolerance: base.frame.height * 0.7)
            }
            .map { _ in Void() }
        return ControlEvent(events: source)
    }
}

