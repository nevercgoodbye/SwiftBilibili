//
//  DanceHeaderAnimator.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ESPullToRefresh

final class DanceHeaderAnimator: UIView,ESRefreshProtocol,ESRefreshAnimatorProtocol {

    var view: UIView { return self }
    
    var insets: UIEdgeInsets = UIEdgeInsets.zero
    
    var trigger: CGFloat = 100
    
    var executeIncremental: CGFloat = 100

    var state: ESRefreshViewState = .pullToRefresh
    
    var duration : CGFloat = 0.3
    
    private let animationImageView = UIImageView().then{
        $0.image = UIImage(named:"animation_refresh_dance_1")
        $0.animationImages = [UIImage(named:"animation_refresh_dance_1")!,
                              UIImage(named:"animation_refresh_dance_2")!,
                              UIImage(named:"animation_refresh_dance_3")!,
                              UIImage(named:"animation_refresh_dance_4")!]
        $0.animationDuration = 0.3
        $0.animationRepeatCount = 0
        $0.contentMode = .center
    }
    
    private let arrowImageView = UIImageView().then{
        $0.image = Image.Home.downArrow
    }
    
    private let textLabel = UILabel().then{
        $0.textColor = .db_black
        $0.font = Font.SysFont.sys_15
        $0.text = "再拉，再拉就刷给你看"
    }
    
    private let loadingActivity = UIActivityIndicatorView(activityIndicatorStyle: .gray).then{
        $0.isHidden = true
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(animationImageView)
        addSubview(arrowImageView)
        addSubview(textLabel)
        addSubview(loadingActivity)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func refreshAnimationBegin(view: ESRefreshComponent) {
        loadingActivity.startAnimating()
        animationImageView.startAnimating()
        loadingActivity.isHidden = false
        arrowImageView.isHidden = true
        
    }
    
    func refreshAnimationEnd(view: ESRefreshComponent) {
        animationImageView.stopAnimating()
        arrowImageView.isHidden = false
        loadingActivity.isHidden = true
        loadingActivity.stopAnimating()
    }
    
    func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        //Do nothing
    }
    
    
    func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        
        switch state {
        case .pullToRefresh: //普通状态
            textLabel.text = "再拉，再拉就刷给你看"
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, animations: {
                self.arrowImageView.transform = .identity
            })
        case .releaseToRefresh: //拉到了刷新状态
            textLabel.text = "够了啦,松开人家嘛"
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, animations: {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
            })
        case .refreshing: //刷新中
            textLabel.text = "耍呀,耍呀,刷完了喵^w^"
            self.setNeedsLayout()
        default:break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        UIView.performWithoutAnimation {
            
            animationImageView.snp.makeConstraints({ (make) in
                make.top.equalTo(10)
                make.centerX.equalToSuperview()
            })
            
            textLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(animationImageView.snp.bottom).offset(10)
                make.left.equalTo(animationImageView).offset(5)
            })
            
            arrowImageView.snp.makeConstraints({ (make) in
                make.right.equalTo(animationImageView.snp.left)
                make.bottom.equalTo(textLabel).offset(5)
                make.size.equalTo(CGSize(width: 30, height: 30))
            })
            loadingActivity.snp.makeConstraints { (make) in
                make.centerY.equalTo(textLabel)
                make.right.equalTo(arrowImageView).offset(-5)
                make.size.equalTo(CGSize(width: 20, height: 20))
            }
        }
    }
}
