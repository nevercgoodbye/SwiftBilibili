//
//  Refreshable.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/24.
//  Copyright © 2018年 罗文. All rights reserved.
//

import RxSwift
import ESPullToRefresh
import RxCocoa

enum PullRefreshType {
    case dance
    case rabbit
    case tv
    case none
}

enum BilibiliRefreshStatus {
    case none
    case beginHeaderRefresh
    case endHeaderRefresh
    case beginFooterRefresh
    case endFooterRefresh
    case noMoreData
}

protocol Refreshable {}

extension Refreshable where Self : UIViewController {
    
    @discardableResult
    func setupRefreshHeader(_ scrollView: UIScrollView,_ headerRefrehType:PullRefreshType = .tv,_ refreshHandler: @escaping () -> Void) -> ESRefreshHeaderView? {
        
        switch headerRefrehType {
        case .tv:
           return scrollView.es.addPullToRefresh(animator: TVHeaderAnimator(), handler: refreshHandler)
        case .dance:
           return scrollView.es.addPullToRefresh(animator: DanceHeaderAnimator(), handler: refreshHandler)
        case .rabbit:
           return scrollView.es.addPullToRefresh(animator: RabbitHeaderAnimator(), handler: refreshHandler)
        default: return nil
        }
    }
}

extension Refreshable where Self : UIScrollView {
    
    @discardableResult
    func setupRefreshHeader(_ headerRefrehType:PullRefreshType = .tv,_ refreshHandler: @escaping () -> Void) -> ESRefreshHeaderView? {
        switch headerRefrehType {
        case .tv:
            return self.es.addPullToRefresh(animator: TVHeaderAnimator(), handler: refreshHandler)
        case .dance:
            return self.es.addPullToRefresh(animator: DanceHeaderAnimator(), handler: refreshHandler)
        case .rabbit:
            return self.es.addPullToRefresh(animator: RabbitHeaderAnimator(), handler: refreshHandler)
        default: return nil
        }
    }
}

protocol OutputRefreshProtocol {
    
    var refreshStatus: BehaviorRelay<BilibiliRefreshStatus>{get}
}

extension OutputRefreshProtocol {
    
    func autoSetRefreshStatus(header: ESRefreshHeaderView? = nil,footer: ESRefreshFooterView? = nil) -> Disposable {
        
        return refreshStatus.subscribe(onNext: { (status) in
            switch status {
            case .beginHeaderRefresh:
                header?.startRefreshing()
            case .endHeaderRefresh:
                header?.stopRefreshing()
            case .beginFooterRefresh:
                footer?.startRefreshing()
            case .endFooterRefresh:
                footer?.stopRefreshing()
            case .noMoreData:
                footer?.resetNoMoreData()
            default:break
            }
            
        })
    }
}


