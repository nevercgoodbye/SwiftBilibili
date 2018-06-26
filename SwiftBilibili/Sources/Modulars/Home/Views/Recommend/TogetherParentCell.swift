//
//  TogetherParentCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/17.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import Dollar

class TogetherParentCell: BaseCollectionViewCell {
    
    private var togetherModel: RecommendTogetherModel?
    
    let coverImageView = UIImageView().then{
        $0.isUserInteractionEnabled = false
    }
    
    let longPressShadowView = UIView().then{
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.05)
    }
    
    let titleLabel = UILabel().then{
        $0.font = Font.SysFont.sys_13
        $0.textColor = .db_black
        $0.numberOfLines = 0
    }
    
    let descLabel = UILabel().then{
        $0.font = Font.SysFont.sys_12
        $0.textColor = .db_lightGray
    }
    
    let dislikeButton = UIButton().then{
        $0.setBackgroundImage(Image.Home.dislike, for: .normal)
    }
    
    let effectView = UIVisualEffectView().then{
        $0.effect = UIBlurEffect(style: .light)
    }

    let dislikeMaskView = TogetherDislikeMaskView.loadFromNib()
    
    override func initialize() {
        contentView.backgroundColor = .white
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(dislikeButton)
    }
    
    
    private func setupPopOverView(_ togetherModel: RecommendTogetherModel,_ completion:(()->())? = nil) {

        let popOverView = TogetherDislikePopOverView()
        
        if togetherModel.goto == .av {
            popOverView.settings.overView.viewWidth = kDislikeViewMaxWidth
            popOverView.footerData = DislikeFooterData(upName: togetherModel.dislike_reasons?[0].reason_name, zoneName: togetherModel.dislike_reasons?[1].reason_name, remarkName: togetherModel.dislike_reasons?[2].reason_name)
            
            let watchLaterTitle = togetherModel.isSetWatchLater ? "已添加至稍后观看" : "添加至稍后观看"
            popOverView.addAction(Action(ActionData(title: watchLaterTitle, image: Image.Home.video),handler:{[unowned self] action in
                
                if let isSetWatchLater = self.togetherModel?.isSetWatchLater,isSetWatchLater {
                    BilibiliToaster.show("已添加")
                }else{
                    RecommendTogetherModel.event.onNext(.watchLater(idx: self.togetherModel?.idx,isCancle:false))
                }
            }))
            popOverView.addAction(Action(ActionData(title: "使用小窗观看", image: Image.Home.smallWindow),handler:{ action in
                BilibiliToaster.show("小窗播放")
            }))
            popOverView.dislikeTapSubject.subscribe(onNext: {[unowned self] (dislikeModel) in
                
                popOverView.dismiss(isNeedAnimation: true)
                
                self.showDislike(dislikeModel: dislikeModel)
                
            }).disposed(by: rx.disposeBag)
            
        }else {
            popOverView.settings.overView.viewWidth = kDislikeViewMinWidth
            
            popOverView.addAction(Action(ActionData(title: "不感兴趣", image: Image.Home.noInterest),handler:{[unowned self] action in
                
                
                if self.togetherModel!.goto == .ad {

                    self.showDislike(isDelete: true)
                    
                }else{
                    
                   let dislikeModel = TogetherDislikeModel(reason_name: "不感兴趣", reason_type: .noInterest)
                    
                    self.showDislike(dislikeModel: dislikeModel)
                }
                
            }))
        }
        popOverView.show(pointView: self.dislikeButton, completion)
    }

    private func showDislike(dislikeModel: TogetherDislikeModel? = nil,isDelete:Bool = false) {
        
        if !isDelete {
            isShowDislikeView(true)
        }
        BilibiliToaster.show("将减少相似内容推荐")
        
        RecommendTogetherModel.event.onNext(.dislikeReason(idx: self.togetherModel?.idx, dislikeModel: dislikeModel,isDelete:isDelete))
    }
    
    //MARK: - 推荐相关
    func isShowDislikeView(_ isDislike:Bool) {
        
        if isDislike {
            
            contentView.addSubview(effectView)
            contentView.addSubview(dislikeMaskView)
            
            effectView.snp.makeConstraints { (make) in
                make.edges.equalTo(coverImageView)
            }
            
            dislikeMaskView.snp.makeConstraints({ (make) in

                make.edges.equalToSuperview()
            })
        }else{
            effectView.removeFromSuperview()
            dislikeMaskView.removeFromSuperview()
            
            effectView.snp.removeConstraints()
            dislikeMaskView.snp.removeConstraints()
        }
        
        if togetherModel?.dislikeName != nil {
            dislikeMaskView.reasonLabel.text = togetherModel?.dislikeName
        }
    }
    
    func commonEvent(togetherModel:RecommendTogetherModel) {
        
        self.togetherModel = togetherModel
        
        dislikeButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
            self.setupPopOverView(togetherModel)
        })
            .disposed(by: disposeBag)
        
        dislikeMaskView.recallSubject.subscribe(onNext: {[unowned self] (_) in
            let isOver = ProcessTimeManager.overSetTime(referenceDate: self.togetherModel?.dislikeRecordTime, compareDate: Date(), targetMinute: kRecommendRecallDislikeMinute)

            if isOver {
                BilibiliToaster.show("超过\(kRecommendRecallDislikeMinute)分钟就不能撤销啦")
            }else{
                self.isShowDislikeView(false)
                RecommendTogetherModel.event.onNext(.dislikeReason(idx: self.togetherModel?.idx, dislikeModel: nil,isDelete:false))
            }

        }).disposed(by: disposeBag)

        contentView.rx.longPressGesture()
            .when(.began)
            .subscribe(onNext: {[unowned self] (longPressGes) in

                self.contentView.addSubview(self.longPressShadowView)
                self.longPressShadowView.snp.makeConstraints { (make) in
                    make.edges.equalTo(0)
                }
                
                if !togetherModel.isDislike {

                    self.setupPopOverView(togetherModel, {
                        self.longPressShadowView.removeFromSuperview()
                        self.longPressShadowView.snp.removeConstraints()
                    })

                }else{
                    DispatchQueue.delay(time: 0.25, action: {
                        self.longPressShadowView.removeFromSuperview()
                        self.longPressShadowView.snp.removeConstraints()
                    })
                }
            })
            .disposed(by: disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setShadow()
        
        contentView.clipRectCorner(direction: .allCorners, cornerRadius: kCornerRadius)
        
        coverImageView.snp.remakeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kNormalItemHeight * 0.6)
        }
        
        titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(coverImageView.snp.bottom).offset(10)
            make.right.equalTo(-10)
            make.height.lessThanOrEqualTo(32)
        }
        
        descLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(dislikeButton.snp.left).offset(-10)
            make.centerY.equalTo(dislikeButton)
        }
        
        dislikeButton.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
            make.height.equalTo(25)
            make.width.equalTo(20)
        }
    }
}
