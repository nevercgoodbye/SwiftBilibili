//
//  TogetherLiveCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/7.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class TogetherLiveCell: TogetherParentCell,View {
    
    private let shadowImageView = UIImageView().then{
        $0.image = Image.Home.shadow
    }
    
    private let liveTagLabel = UILabel().then{
        $0.text = "直播"
        $0.borderWidth = 1
        $0.cornerRadius = 2
        $0.font = Font.SysFont.sys_11
        $0.textAlignment = .center
        $0.textColor = .db_pink
        $0.borderColor = .db_pink
    }
    
    private let anchorNameLabel = UILabel().then{
        $0.font = Font.SysFont.sys_12
        $0.textColor = .db_white
    }
    
    private let onlineButton = BilibiliButton().then{
        $0.setTitleColor(.db_white, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_10
        $0.isUserInteractionEnabled = false
        $0.setImage(Image.Home.online, for: .normal)
        $0.imagePosition = .left
        $0.imageSize = CGSize(width: 15, height: 12)
    }
    
    override func initialize() {
        super.initialize()
        contentView.addSubview(liveTagLabel)
        contentView.addSubview(shadowImageView)
        contentView.addSubview(anchorNameLabel)
        contentView.addSubview(onlineButton)
    }
    
    func bind(reactor: TogetherLiveCellReactor) {
        
        let placeholderSize = CGSize(width: reactor.currentState.cellSize.width, height: reactor.currentState.cellSize.height * 0.6)
        
        reactor.state.map{$0.coverURL}
            .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
            .disposed(by: disposeBag)
        reactor.state.map{$0.anchorName}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: anchorNameLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.online}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: onlineButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        reactor.state.map{$0.title}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.desc}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: descLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.online == nil}
            .distinctUntilChanged()
            .bind(to: onlineButton.rx.isHidden)
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
        
        
        anchorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(shadowImageView.snp.centerX)
            make.bottom.equalTo(shadowImageView.snp.bottom).offset(-5)
        }
        
        onlineButton.snp.makeConstraints { (make) in
            make.right.equalTo(dislikeButton.snp.right)
            make.bottom.equalTo(anchorNameLabel.snp.bottom)
            make.left.equalTo(shadowImageView.snp.centerX)
        }
        
        liveTagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(dislikeButton)
            make.width.equalTo(28)
            make.height.equalTo(16)
        }
        
        descLabel.snp.remakeConstraints { (make) in
            
            make.left.equalTo(liveTagLabel.snp.right).offset(10)
            make.right.equalTo(dislikeButton.snp.left).offset(-10)
            make.centerY.equalTo(dislikeButton)
        }
    }
}
