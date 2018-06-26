//
//  TogetherSpecialCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/8.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class TogetherSpecialCell: TogetherParentCell,View {
    
    private let badgeLabel = UILabel().then{
        $0.borderWidth = 1
        $0.cornerRadius = 2
        $0.font = Font.SysFont.sys_11
        $0.textAlignment = .center
        $0.textColor = .db_pink
        $0.borderColor = .db_pink
    }
    
    override func initialize() {
        super.initialize()
        contentView.addSubview(badgeLabel)
    }
    
    func bind(reactor: TogetherSpecialCellReactor) {
        
        let placeholderSize = CGSize(width: reactor.currentState.cellSize.width, height: reactor.currentState.cellSize.height * 0.6)
        
        reactor.state.map{$0.coverURL}
            .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
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
        reactor.state.map{$0.badge}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: badgeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        badgeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(dislikeButton)
            make.width.equalTo(reactor!.currentState.badgeSize.width + 4.f)
            make.height.equalTo(reactor!.currentState.badgeSize.height + 4.f)
        }
        
        descLabel.snp.remakeConstraints { (make) in
            
            make.left.equalTo(badgeLabel.snp.right).offset(10)
            make.right.equalTo(dislikeButton.snp.left).offset(-10)
            make.centerY.equalTo(dislikeButton)
        }
    }
}
