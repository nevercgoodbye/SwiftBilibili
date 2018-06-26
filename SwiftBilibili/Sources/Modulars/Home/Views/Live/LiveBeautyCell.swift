//
//  LiveBeautyCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/22.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class LiveBeautyCell: BaseCollectionViewCell,View {
    
    // MARK: UI
    private let coverImageView = UIImageView().then{
        $0.cornerRadius = kCornerRadius
    }
    
    private let shadowImageView = UIImageView().then{
        $0.image = Image.Home.shadow
    }
    
    private let anchorNameLabel = UILabel().then{
        $0.textColor = .db_white
        $0.font = Font.SysFont.sys_10
    }
    
    private let onlinesButton = BilibiliButton().then{
        $0.setTitleColor(.db_white, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_10
        $0.isUserInteractionEnabled = false
        $0.setImage(Image.Home.play, for: .normal)
        $0.contentHorizontalAlignment = .right
        $0.space = 5
        $0.imagePosition = .left
        $0.imageSize = CGSize(width: 12, height: 12)
    }
    
    // MARK: Initializing
    override func initialize() {
        contentView.addSubview(coverImageView)
        coverImageView.addSubview(shadowImageView)
        shadowImageView.addSubview(anchorNameLabel)
        shadowImageView.addSubview(onlinesButton)
    }
    
    func bind(reactor: LiveBeautyCellReactor) {
    
        reactor.state.map{$0.coverURL}
            .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:self.size)))
            .disposed(by: disposeBag)
        reactor.state.map{$0.anchorName}
            .distinctUntilChanged()
            .bind(to: anchorNameLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.online}
            .distinctUntilChanged()
            .bind(to: onlinesButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: disposeBag)
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setShadow()
        
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        shadowImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kShadowImageHeight)
        }
        
        anchorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(onlinesButton)
            make.width.equalTo(100)
            make.height.equalTo(onlinesButton.snp.height)
        }
        
        onlinesButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
            make.height.equalTo(12)
            make.left.equalTo(anchorNameLabel.snp.right).offset(10)
        }
    }
}
