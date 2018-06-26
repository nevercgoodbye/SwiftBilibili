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
    private let backgroundImageView = UIImageView().then{
        $0.cornerRadius = kCornerRadius
        $0.backgroundColor = .db_white
        $0.isUserInteractionEnabled = true
    }
    
    private let coverImageView = UIImageView().then{
        $0.isUserInteractionEnabled = true
    }
    
    private let shadowImageView = UIImageView().then{
        $0.image = Image.Home.shadow
    }
    
    private let anchorNameLabel = UILabel().then{
        $0.textColor = .db_white
        $0.font = Font.SysFont.sys_13
    }
    
    private let liveTitleLabel = UILabel().then{
        $0.font = Font.SysFont.sys_14
        $0.textColor = .db_black
    }
    
    override func initialize() {
        contentView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(coverImageView)
        backgroundImageView.addSubview(liveTitleLabel)
        coverImageView.addSubview(shadowImageView)
        shadowImageView.addSubview(anchorNameLabel)
    }
    
    func bind(reactor: LiveRoundRoomCellReactor) {
        
        let placeholderSize = CGSize(width: self.width, height: self.height * 3/4)
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
        
        setShadow()
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(self.height * 3 / 4)
        }
        
        shadowImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kShadowImageHeight)
        }
        
        anchorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        liveTitleLabel.snp.makeConstraints { (make) in
           make.left.equalTo(10)
           make.right.equalTo(-10)
           make.bottom.equalToSuperview()
           make.top.equalTo(coverImageView.snp.bottom)
        }

    }
    
    
}
