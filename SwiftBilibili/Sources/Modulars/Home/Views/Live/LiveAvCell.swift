//
//  LiveAvCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import URLNavigator

final class LiveAvCell: BaseCollectionViewCell,View {
    
    private let coverImageView = UIImageView().then{
        $0.isUserInteractionEnabled = true
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
        $0.setImage(Image.Home.playTime, for: .normal)
        //$0.contentHorizontalAlignment = .right
        $0.space = 5
        $0.imagePosition = .left
        $0.imageSize = CGSize(width: 12, height: 12)
    }
    
    private let liveTitleLabel = UILabel().then{
        $0.font = Font.SysFont.sys_13
        $0.textColor = .db_black
    }
    
    private let categoryLabel = UILabel().then{
        $0.font = Font.SysFont.sys_12
        $0.textColor = .db_lightGray
    }
    
    // MARK: Initializing
    override func initialize() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(liveTitleLabel)
        contentView.addSubview(categoryLabel)
        coverImageView.addSubview(shadowImageView)
        shadowImageView.addSubview(anchorNameLabel)
        shadowImageView.addSubview(onlinesButton)
     }
    
    // MARK: Configuring
    func bind(reactor: LiveAvCellReactor) {
        
        let placeholderSize = CGSize(width: self.width, height: kLiveItemHeight*0.6)
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
        reactor.state.map{$0.category}
            .distinctUntilChanged()
            .bind(to: categoryLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.online}
            .distinctUntilChanged()
            .bind(to: onlinesButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: disposeBag)
    }
    
    // MARK: Size
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        if reactor!.live.isLeft {
            coverImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(10)
                make.left.equalTo(kCollectionItemPadding)
                make.right.equalTo(-kCollectionItemPadding/2)
                make.height.equalTo(kLiveItemHeight*0.6)
            }
        }else{
            coverImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(10)
                make.left.equalTo(kCollectionItemPadding/2)
                make.right.equalTo(-kCollectionItemPadding)
                make.height.equalTo(kLiveItemHeight*0.6)
            }
            
        }
        
        shadowImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kShadowImageHeight)
        }
        
        onlinesButton.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
        }
        
        anchorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(onlinesButton)
            make.right.equalTo(onlinesButton.snp.left).offset(-10)
            make.height.equalTo(onlinesButton.snp.height)
        }
        
        liveTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(coverImageView)
            make.top.equalTo(coverImageView.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
        categoryLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(coverImageView)
            make.top.equalTo(liveTitleLabel.snp.bottom).offset(5)
        }
    }
    
}
