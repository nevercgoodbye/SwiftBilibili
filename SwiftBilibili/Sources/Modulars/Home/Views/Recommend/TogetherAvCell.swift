//
//  TogetherAvCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/17.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit


final class TogetherAvCell: TogetherParentCell,View {
    
    private struct Metric {
        static let playTimesButtonLeft = 5.f
        static let playTimesButtonBottom = -5.f
        static let playTimesButtonHeight = 12.f
        static let playTimeLabelRight = -5.f
        static let danmakusButtonLeft = 10.f
        static let categoryLabelLeft = 10.f
        static let categoryLabelRight = -5.f
        static let rcmdLabelCornerRadius = 2.f
        static let typeLabelBorderWidth = 1.f
        static let typeLabelHeight = 18.f
    }
    
    private let shadowImageView = UIImageView().then{
        $0.image = Image.Home.shadow
    }
    
    
    private let playTimesButton = BilibiliButton().then{
        $0.setTitleColor(.db_white, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_10
        $0.isUserInteractionEnabled = false
        $0.contentHorizontalAlignment = .left
        $0.setImage(Image.Home.play, for: .normal)
        $0.imagePosition = .left
        $0.imageSize = CGSize(width: Metric.playTimesButtonHeight, height: Metric.playTimesButtonHeight)
    }
    
    private let danmakusButton = BilibiliButton().then{
        $0.setTitleColor(.db_white, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_10
        $0.isUserInteractionEnabled = false
        $0.setImage(Image.Home.danmakus, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.imagePosition = .left
        $0.imageSize = CGSize(width: Metric.playTimesButtonHeight, height: Metric.playTimesButtonHeight)
    }
    
    private let playTimeLabel = UILabel().then{
        $0.textColor = .db_white
        $0.font = Font.SysFont.sys_10
    }

    private let recommendButton = UIButton().then{
         $0.titleLabel?.font = Font.SysFont.sys_12
         $0.setTitleColor(UIColor.db_white, for: .normal)
         $0.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5)
         $0.cornerRadius = Metric.rcmdLabelCornerRadius
    }
    
    override func initialize() {

        super.initialize()
        contentView.addSubview(recommendButton)
        contentView.addSubview(shadowImageView)
        contentView.addSubview(playTimesButton)
        contentView.addSubview(danmakusButton)
        contentView.addSubview(playTimeLabel)
    }
    
    func bind(reactor: TogetherAvCellReactor) {
        
        let placeholderSize = CGSize(width: reactor.currentState.cellSize.width, height: reactor.currentState.cellSize.height * 0.6)

        reactor.state.map{$0.coverURL}
            .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
            .disposed(by: disposeBag)
        reactor.state.map{$0.title}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.duration}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: playTimeLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.desc}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: descLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.rcmdTitle}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: recommendButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        reactor.state.map{$0.rcmdColor}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: recommendButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        reactor.state.map{$0.playTimes}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: playTimesButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        reactor.state.map{$0.danmakus}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: danmakusButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        //显示状态
        reactor.state.map{$0.rcmdTitle != nil}
            .distinctUntilChanged()
            .bind(to: descLabel.rx.isHidden)
            .disposed(by: disposeBag)
        reactor.state.map{$0.desc == nil}
            .distinctUntilChanged()
            .bind(to: descLabel.rx.isHidden)
            .disposed(by: disposeBag)
        reactor.state.map{$0.rcmdTitle == nil}
            .distinctUntilChanged()
            .bind(to: recommendButton.rx.isHidden)
            .disposed(by: disposeBag)
        reactor.state.map{$0.playTimes == nil}
            .distinctUntilChanged()
            .bind(to: playTimesButton.rx.isHidden)
            .disposed(by: disposeBag)
        reactor.state.map{$0.danmakus == nil}
            .distinctUntilChanged()
            .bind(to: danmakusButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)

        self.commonEvent(togetherModel: reactor.together)
        self.isShowDislikeView(reactor.together.isDislike)
        
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()

        shadowImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(coverImageView)
            make.height.equalTo(kShadowImageHeight)
        }
        
        playTimesButton.snp.makeConstraints { (make) in
            make.left.equalTo(Metric.playTimesButtonLeft)
            make.bottom.equalTo(shadowImageView.snp.bottom).offset(Metric.playTimesButtonBottom)
            make.height.equalTo(Metric.playTimesButtonHeight)
        }
        
        danmakusButton.snp.makeConstraints { (make) in
            make.left.equalTo(playTimesButton.snp.right).offset(Metric.danmakusButtonLeft)
            make.centerY.equalTo(playTimesButton)
            make.height.equalTo(playTimesButton)
        }
        
        playTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(Metric.playTimeLabelRight)
            make.centerY.equalTo(playTimesButton)
            make.height.equalTo(playTimesButton)
        }
        
        recommendButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.centerY.equalTo(dislikeButton)
        }
    }
}
