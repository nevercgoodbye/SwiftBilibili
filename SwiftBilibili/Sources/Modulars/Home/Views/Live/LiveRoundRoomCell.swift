//
//  LiveRoundRoomCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class LiveRoundRoomCell: BaseCollectionViewCell,View {
    
    // MARK: UI
    private let coverImageView = UIImageView().then{
        $0.isUserInteractionEnabled = true
        $0.cornerRadius = kCornerRadius
    }
    
    private let shadowImageView = UIImageView().then{
        $0.image = Image.Home.shadow
    }
    
    private let anchorNameLabel = UILabel().then{
        $0.textColor = .db_white
        $0.font = Font.SysFont.sys_12
    }
    
    private let liveTitleLabel = UILabel().then{
        $0.font = Font.SysFont.sys_14
        $0.textColor = .db_black
    }
    
    override func initialize() {
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(liveTitleLabel)
        coverImageView.addSubview(shadowImageView)
        shadowImageView.addSubview(anchorNameLabel)
    }
    
    func bind(reactor: LiveRoundRoomCellReactor) {
        
        let placeholderSize = CGSize(width: self.width, height: self.height * 0.6)
        reactor.state.map{$0.coverURL}
            .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
            .disposed(by: disposeBag)
        reactor.state.map{$0.liveTitle}
            .distinctUntilChanged()
            .bind(to: liveTitleLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.anchorName}
            .distinctUntilChanged()
            .bind(to: anchorNameLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: disposeBag)
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leftMargin = reactor!.live.isLeft ? kCollectionItemPadding : kCollectionItemPadding/2
        let rightMargin = reactor!.live.isLeft ? -kCollectionItemPadding/2 : -kCollectionItemPadding
        
        coverImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(leftMargin)
            make.right.equalTo(rightMargin)
            make.height.equalTo(kLiveItemHeight*0.6)
        }
        
        shadowImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kShadowImageHeight)
        }
        
        anchorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.bottom.equalTo(-5)
        }
        
        liveTitleLabel.snp.makeConstraints { (make) in
           make.left.right.equalTo(coverImageView)
           make.top.equalTo(coverImageView.snp.bottom).offset(10)
        }

    }
    
    
}
