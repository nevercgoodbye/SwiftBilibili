//
//  PullToRefresh+Rx.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/20.
//  Copyright © 2018年 罗文. All rights reserved.
//
import RxCocoa
import RxSwift
import ESPullToRefresh

extension Reactive where Base: ESRefreshHeaderView {
    
    var isRefreshing: Binder<Bool> {
        return Binder(self.base) { headerView, refresh in
            if refresh {
               headerView.startRefreshing()
            } else {
               headerView.stopRefreshing()
            }
        }
    }
}
