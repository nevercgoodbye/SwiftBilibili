//
//  RabbitHeaderAnimator.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ESPullToRefresh
import SwiftTimer

final class RabbitHeaderAnimator: UIView,ESRefreshProtocol,ESRefreshAnimatorProtocol {

    fileprivate struct Metric {
        static let rabbitEarWidth = 25.f
        static let rabbitEarHeight = 6.f
        static let triggerHeight = 100.f
        static let maskViewHeight = 55.f
        static let singleViewSize = CGSize(width: 8, height: 4)
        static let textLabelBottom = -80.f
        static let singleAnimationDuration = 1.f
        static let refreshAnimationDuration = 1.0.f
    }
    
    //协议要求的变量
    var view: UIView { return self }
    
    var insets: UIEdgeInsets = UIEdgeInsets.zero
    
    var trigger: CGFloat = Metric.triggerHeight
    
    var executeIncremental: CGFloat = Metric.maskViewHeight
    
    var state: ESRefreshViewState = .pullToRefresh
    
    var duration : CGFloat = Metric.refreshAnimationDuration
    
    var isSuccess: Bool = true
    
    //自定义变量
    private var animateTimer:SwiftTimer?
    private var isUpdateFrame: Bool = false
    //视图
    private let textLabel = UILabel().then{
        $0.text = "再用点力!"
        $0.textAlignment = .center
        $0.textColor = UIColor(244,169,191)
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.sizeToFit()
        $0.alpha = 0
    }
    
    private let grayMaskView = UIImageView().then{
        $0.image = UIImage.size(CGSize(width: kScreenWidth, height: Metric.maskViewHeight)).color(.db_gray).corner(topLeft: kCornerRadius, topRight: kCornerRadius, bottomLeft: 0, bottomRight: 0).image
    }
    
    private let leftEarView = UIImageView().then{
        $0.image = UIImage.size(CGSize(width: Metric.rabbitEarWidth, height: Metric.rabbitEarHeight)).color(.db_gray).image
        $0.cornerRadius = Metric.rabbitEarHeight/2
    }
    
    private let rightEarView = UIImageView().then{
        $0.image = UIImage.size(CGSize(width: Metric.rabbitEarWidth, height: Metric.rabbitEarHeight)).color(.db_gray).image
        $0.cornerRadius = Metric.rabbitEarHeight/2
    }

    private let firstSingleView = UIImageView().then{
        $0.image = UIImage.size(Metric.singleViewSize).color(.clear).image
        $0.borderColor = .db_gray
        $0.borderWidth = 0.3
        $0.cornerRadius = 2
        $0.isHidden = true
    }
    
    private let secondSingleView = UIImageView().then{
        $0.image = UIImage.size(Metric.singleViewSize).color(.clear).image
        $0.borderColor = .db_gray
        $0.borderWidth = 0.3
        $0.cornerRadius = 2
        $0.isHidden = true
    }
    
    private let animationImageView = UIImageView().then{
        $0.animationImages = [UIImage(named:"animation_refresh_rabbit_1")!,
                              UIImage(named:"animation_refresh_rabbit_2")!,
                              UIImage(named:"animation_refresh_rabbit_3")!]
        $0.animationDuration = Double(Metric.refreshAnimationDuration)
        $0.animationRepeatCount = 0
        $0.contentMode = .center
        $0.isHidden = true
    }
    
    private let animationTextLabel = UILabel().then{
        $0.textAlignment = .center
        $0.textColor = UIColor.db_darkGray
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.isHidden = true
    }
    
    //初始化
    override init(frame: CGRect) {
        
        super.init(frame: frame)
       
        self.backgroundColor = .db_pink
    
        addSubview(grayMaskView)
        addSubview(textLabel)
        addSubview(firstSingleView)
        addSubview(secondSingleView)
        grayMaskView.addSubview(leftEarView)
        grayMaskView.addSubview(rightEarView)
        grayMaskView.addSubview(animationImageView)
        grayMaskView.addSubview(animationTextLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshAnimationBegin(view: ESRefreshComponent) {
        //清除耳朵动画
        clearEarAnimation()
        animationImageView.isHidden = false
        animationTextLabel.isHidden = false
        animationImageView.startAnimating()
        animationTextLabel.text = "正在更新.."
    }

    func refreshAnimationEnd(view: ESRefreshComponent) {
        animationImageView.isHidden = true
        animationImageView.stopAnimating()
        animationTextLabel.text = isSuccess ? "更新完成" : "更新失败"
        DispatchQueue.delay(time: 0.5) {[unowned self] in
           self.animationTextLabel.isHidden = true
        }
    }
    
    func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        
        animationTextLabel.isHidden = true
        animationImageView.isHidden = true
        
        if !isUpdateFrame {
            self.frame = CGRect(x: 0, y: -kScreenHeight + Metric.maskViewHeight, width: kScreenWidth, height: kScreenHeight)
            isUpdateFrame = true
        }
        
        //如果拖动范围还在maskview内则返回
        if progress <= Metric.maskViewHeight/trigger { return }
        
        let offest = progress * trigger
        
        textLabel.alpha = (offest - Metric.maskViewHeight)/(Metric.triggerHeight-Metric.maskViewHeight)
        
        textLabel.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(Metric.textLabelBottom)
        }
        
        if offest < trigger {
            clearEarAnimation()
            let rota = CGFloat.pi/2 * textLabel.alpha
            startEarRota(rota: rota)
        }else{
            
            let bottomOffest = Metric.textLabelBottom - (offest - trigger)
            textLabel.snp.remakeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(bottomOffest)
            })
            
            startEarRota(rota: CGFloat.pi/2)
            
            if animateTimer == nil {
                addAnimation()
                animateTimer = SwiftTimer.repeaticTimer(interval: DispatchTimeInterval.seconds(2), handler: {[weak self] (_) in
                    self?.addAnimation()
                })
                animateTimer?.start()
            }
            
        }
        
    }
    
    func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        
        guard self.state != state else { return }
        
        self.state = state
        
        switch state {
        case .pullToRefresh,.refreshing:
             textLabel.text = "再用力点"
        case .releaseToRefresh:
             textLabel.text = "松手加载"
        default:break
        }
    }
    //添加动画
    func addAnimation() {
        
        firstSingleView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.firstSingleView.transform = self.firstSingleView.transform.scaledBy(x: 16, y: 16)
            self.firstSingleView.alpha = 0
        }, completion: { (completed) in
            self.firstSingleView.transform = CGAffineTransform.identity
            self.firstSingleView.alpha = 1
            self.firstSingleView.isHidden = true
        })
        
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            self.secondSingleView.isHidden = false
            UIView.animate(withDuration: 1, animations: {
                self.secondSingleView.transform = self.secondSingleView.transform.scaledBy(x: 16, y: 16)
                self.secondSingleView.alpha = 0
            }, completion: { (complete) in
                self.secondSingleView.transform = CGAffineTransform.identity
                self.secondSingleView.alpha = 1
                self.secondSingleView.isHidden = true
            })
        })
        
        leftEarView.layer.add(earKeyframeAnimation(isRight:false), forKey: "left")
        rightEarView.layer.add(earKeyframeAnimation(isRight: true), forKey: "right")
    }
    
    private func earKeyframeAnimation(isRight:Bool) -> CAKeyframeAnimation {
        var delta:CGFloat = 1
        if isRight {
            delta = -1
        }
        let earAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        earAnimation.values = [delta*CGFloat.pi/2,delta*CGFloat.pi/4,delta*CGFloat.pi/2,delta*CGFloat.pi/4,delta*CGFloat.pi/2]
        earAnimation.keyTimes = [0,0.25,0.5,0.75,1]
        earAnimation.duration = 0.75
        return earAnimation
    }
    
    //清除动画
    private func clearEarAnimation() {
        animateTimer?.suspend()
        animateTimer = nil
        
        leftEarView.layer.removeAllAnimations()
        rightEarView.layer.removeAllAnimations()
    }
    
    //开始耳朵旋转
    private func startEarRota(rota:CGFloat) {
        var Ltransform = CGAffineTransform.identity
        Ltransform = Ltransform.rotated(by: rota)
        
        var Rtransform = CGAffineTransform.identity
        Rtransform = Rtransform.rotated(by: -rota)
        
        leftEarView.transform = Ltransform
        rightEarView.transform = Rtransform
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        grayMaskView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        //左耳
        leftEarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(grayMaskView.snp.centerX).offset(-Metric.rabbitEarWidth/2)
        }
        leftEarView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        //右耳
        rightEarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(grayMaskView.snp.centerX).offset(Metric.rabbitEarWidth/2)
        }
        rightEarView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        //信号动画view
        firstSingleView.snp.makeConstraints { (make) in
            make.top.equalTo(grayMaskView.snp.top).offset(-15)
            make.left.equalTo(grayMaskView.snp.centerX)
        }
        secondSingleView.snp.makeConstraints { (make) in
            make.top.equalTo(grayMaskView.snp.top).offset(-15)
            make.left.equalTo(grayMaskView.snp.centerX)
        }
        animationImageView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.centerX.equalToSuperview()
        }
        animationTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(animationImageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        

    }
}
