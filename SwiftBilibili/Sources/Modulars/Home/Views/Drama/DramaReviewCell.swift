//
//  DramaReviewCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class DramaReviewCell: BaseCollectionViewCell,View {
    
    private struct Metric {
        static let coverImageViewHeight = 70.f
        static let coverImageViewWidth = 50.f
        static let coverImageViewTop = 20.f
        static let avaterImageViewSize = CGSize(width: 20, height: 20)
        static let titleLabelRight = -15.f
        static let titleLabelHeight = 16.f
        static let contentLabelTop = 10.f
        static let contentLabelMaxHeight = 32.f
        static let avaterImageViewBottom = -10.f
        static let userNameLabelLeft = 10.f
        static let likesButtonRight = -30.f
        static let bottomLineHeight = 0.5.f
    }
    
    let coverImageView = UIImageView().then{
        $0.cornerRadius = kCornerRadius
    }
    
    let titleLabel = UILabel().then{
        $0.textColor = UIColor.db_black
        $0.font = Font.SysFont.sys_14
    }
    
    let contentLabel = UILabel().then{
        $0.textColor = UIColor.db_darkGray
        $0.font = Font.SysFont.sys_13
        $0.numberOfLines = 0
    }
    
    let avaterImageView = UIImageView().then{
        $0.cornerRadius = Metric.avaterImageViewSize.height/2
    }
    
    let userNameLabel = UILabel().then{
        $0.textColor = UIColor.db_darkGray
        $0.font = Font.SysFont.sys_12
    }
    
    let likesButton = BilibiliButton().then{
        $0.setTitleColor(.db_lightGray, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_12
        $0.isUserInteractionEnabled = false
        $0.setImage(Image.Home.danmakus, for: .normal)
        $0.imageSize = CGSize(width:12, height: 12)
    }
    
    let replyButton = BilibiliButton().then{
        $0.setTitleColor(.db_lightGray, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_12
        $0.isUserInteractionEnabled = false
        $0.setImage(Image.Home.play, for: .normal)
        $0.imageSize = CGSize(width:12, height: 12)
    }
    
    let bottomLine = UIView().then{
        $0.backgroundColor = .db_lightGray
    }
    
    override func initialize() {
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(avaterImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(likesButton)
        contentView.addSubview(replyButton)
        contentView.addSubview(bottomLine)
    }
    
    func bind(reactor: DramaReviewCellReactor) {
        
        let placeholderSize = CGSize(width: Metric.coverImageViewWidth, height: Metric.coverImageViewHeight)
        reactor.state.map{$0.coverURL}
            .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
            .disposed(by: disposeBag)
        reactor.state.map{$0.title}
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.content}
            .distinctUntilChanged()
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.avaterURL}
            .bind(to: avaterImageView.rx.image())
            .disposed(by: disposeBag)
        reactor.state.map{$0.uname}
            .distinctUntilChanged()
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.likes}
            .distinctUntilChanged()
            .bind(to: likesButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        reactor.state.map{$0.reply}
            .distinctUntilChanged()
            .bind(to: replyButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        reactor.state.map{!$0.isShowBottomLine}
            .distinctUntilChanged()
            .bind(to: bottomLine.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    class func size(reactor: DramaReviewCellReactor) -> CGSize {
        
        var cellHeight: CGFloat = 0
        
        cellHeight += Metric.coverImageViewHeight
        cellHeight += Metric.coverImageViewTop
        cellHeight += Metric.avaterImageViewSize.height
        cellHeight += -Metric.avaterImageViewBottom
    
        return CGSize(width: kScreenWidth, height: cellHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImageView.snp.makeConstraints { (make) in
            make.width.equalTo(Metric.coverImageViewWidth)
            make.height.equalTo(Metric.coverImageViewHeight)
            make.right.equalTo(-kCollectionItemPadding)
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(coverImageView)
            make.left.equalTo(kCollectionItemPadding)
            make.right.equalTo(coverImageView.snp.left).offset(Metric.titleLabelRight)
            make.height.equalTo(Metric.titleLabelHeight)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.contentLabelTop)
            make.height.lessThanOrEqualTo(Metric.contentLabelMaxHeight)
        }
        
        avaterImageView.snp.makeConstraints { (make) in
            make.size.equalTo(Metric.avaterImageViewSize)
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(Metric.avaterImageViewBottom)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avaterImageView.snp.right).offset(Metric.userNameLabelLeft)
            make.centerY.equalTo(avaterImageView)
        }
        
        replyButton.snp.makeConstraints { (make) in
            make.right.equalTo(coverImageView)
            make.centerY.equalTo(avaterImageView)
        }
        
        likesButton.snp.makeConstraints { (make) in
            make.right.equalTo(replyButton.snp.left).offset(Metric.likesButtonRight)
            make.centerY.equalTo(avaterImageView)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(Metric.bottomLineHeight)
        }
    }
}
