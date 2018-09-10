//
//  TogetherArticleCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/7.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class TogetherArticleCell: TogetherParentCell,View {
    
    private let shadowImageView = UIImageView().then{
        $0.image = Image.Home.shadow
    }
    
    private let playButton = BilibiliButton().then{
        $0.setTitleColor(.db_white, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_10
        $0.isUserInteractionEnabled = false
        $0.setImage(Image.Home.playTime, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.imagePosition = .left
        $0.imageSize = CGSize(width: 12, height: 12)
    }
    
    private let replyButton = BilibiliButton().then{
        $0.setTitleColor(.db_white, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_10
        $0.isUserInteractionEnabled = false
        $0.setImage(Image.Home.danmakus, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.imagePosition = .left
        $0.imageSize = CGSize(width: 12, height: 12)
    }
    
    private let articleTagLabel = UILabel().then{
        $0.text = "文章"
        $0.borderWidth = 1
        $0.cornerRadius = 2
        $0.font = Font.SysFont.sys_11
        $0.textAlignment = .center
        $0.textColor = .db_pink
        $0.borderColor = .db_pink
    }
    
    override func initialize() {
        super.initialize()
        contentView.addSubview(articleTagLabel)
        contentView.addSubview(shadowImageView)
        contentView.addSubview(playButton)
        contentView.addSubview(replyButton)
    }
    
    func bind(reactor: TogetherArticleCellReactor) {
        
        let placeholderSize = CGSize(width: reactor.currentState.cellSize.width, height: reactor.currentState.cellSize.height * 0.6)
        
        reactor.state.map{$0.coverURL}
            .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
            .disposed(by: disposeBag)
        reactor.state.map{$0.play}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: playButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        reactor.state.map{$0.reply}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: replyButton.rx.title(for: .normal))
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
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
        reactor.state.map{$0.play == nil}
            .distinctUntilChanged()
            .bind(to: playButton.rx.isHidden)
            .disposed(by: disposeBag)
        reactor.state.map{$0.reply == nil}
            .distinctUntilChanged()
            .bind(to: replyButton.rx.isHidden)
            .disposed(by: disposeBag)
        self.commonEvent(togetherModel: reactor.together)
        self.isShowDislikeView(reactor.together.isDislike)
        
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        shadowImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(coverImageView)
            make.height.equalTo(kShadowImageHeight)
        }
        
        playButton.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.bottom.equalTo(shadowImageView.snp.bottom).offset(-5)
            make.height.equalTo(12)
        }
        
        replyButton.snp.makeConstraints { (make) in
            make.left.equalTo(playButton.snp.right).offset(10)
            make.centerY.equalTo(playButton)
            make.height.equalTo(12)
        }
        
        articleTagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(dislikeButton)
            make.width.equalTo(28)
            make.height.equalTo(16)
        }
        
        descLabel.snp.remakeConstraints { (make) in
            
            make.left.equalTo(articleTagLabel.snp.right).offset(10)
            make.right.equalTo(dislikeButton.snp.left).offset(-10)
            make.centerY.equalTo(dislikeButton)
        }
    }
    
}
