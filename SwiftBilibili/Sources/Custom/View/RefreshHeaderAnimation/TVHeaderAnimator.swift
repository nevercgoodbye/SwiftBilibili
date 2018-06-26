//
//  TVHeaderAnimator.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/6/20.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ESPullToRefresh

final class TVHeaderAnimator: UIView,ESRefreshProtocol,ESRefreshAnimatorProtocol {

    var view: UIView { return self }
    
    var insets: UIEdgeInsets = UIEdgeInsets.zero
    
    var trigger: CGFloat = 60
    
    var executeIncremental: CGFloat = 60
    
    var state: ESRefreshViewState = .pullToRefresh
    
    var duration : CGFloat = 0.5
    
    private let animationImageView = UIImageView().then{
        $0.image = UIImage(named:"tv_pull_loading_1")
        $0.animationImages = [UIImage(named:"tv_pull_loading_1")!,
                              UIImage(named:"tv_pull_loading_2")!,
                              UIImage(named:"tv_pull_loading_3")!,
                              UIImage(named:"tv_pull_loading_4")!]
        $0.animationDuration = 0.5
        $0.animationRepeatCount = 0
        $0.contentMode = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(animationImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func refreshAnimationBegin(view: ESRefreshComponent) {
        animationImageView.startAnimating()
    }
    
    func refreshAnimationEnd(view: ESRefreshComponent) {
        animationImageView.stopAnimating()
    }
    
    func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        
    }
    
    func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        switch state {
        case .pullToRefresh://普通状态
            animationImageView.stopAnimating()
        case .releaseToRefresh: //拉到了刷新状态
            animationImageView.startAnimating()
        default:break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        animationImageView.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
    }
}
