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
    
    private let liveTitleLabel = UILabel().then{
        $0.font = Font.SysFont.sys_13
        $0.textColor = .db_black
    }
    
    private let categoryLabel = UILabel().then{
        $0.font = Font.SysFont.sys_12
        $0.textColor = .db_lightGray
    }
    
    private let smallWindowButton = UIButton().then{
        $0.setBackgroundImage(Image.Home.dislike, for: .normal)
    }
    
    // MARK: Initializing
    override func initialize() {
        contentView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(coverImageView)
        backgroundImageView.addSubview(liveTitleLabel)
        backgroundImageView.addSubview(categoryLabel)
        backgroundImageView.addSubview(smallWindowButton)
        coverImageView.addSubview(shadowImageView)
        shadowImageView.addSubview(anchorNameLabel)
        shadowImageView.addSubview(onlinesButton)
     }
    
    // MARK: Configuring
    func bind(reactor: LiveAvCellReactor) {
        
        let placeholderSize = CGSize(width: self.width, height: self.height * 2/3)
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
        
        smallWindowButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
            
            let popOverView = TogetherDislikePopOverView()
            popOverView.settings.overView.viewWidth = kDislikeViewMinWidth
            popOverView.addAction(Action(ActionData(title: "小窗播放", image: Image.Home.noInterest),handler:{ action in
                
                
            }))
            popOverView.show(pointView: self.smallWindowButton)
            
        }).disposed(by: disposeBag)
    }
    
    // MARK: Size
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
    
        setShadow()
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kLiveItemHeight * 2 / 3)
        }
        
        shadowImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kShadowImageHeight)
        }
        
        anchorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(onlinesButton)
            make.width.equalTo(90)
            make.height.equalTo(onlinesButton.snp.height)
        }
        
        onlinesButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
            make.height.equalTo(12)
            make.left.equalTo(anchorNameLabel.snp.right).offset(10)
        }
        
        liveTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(coverImageView.snp.bottom).offset(5)
            make.right.equalTo(-10)
            make.height.equalTo(20)
        }
        
        smallWindowButton.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
            make.height.equalTo(25)
            make.width.equalTo(20)
        }
        
        categoryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(liveTitleLabel)
            make.right.equalTo(smallWindowButton.snp.left).offset(-10)
            make.centerY.equalTo(smallWindowButton)
        }
    }
    
}
