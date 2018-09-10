//
//  DramaVerticalCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class DramaVerticalCell: BaseCollectionViewCell,View {
    
    private struct Metric {
        static let coverImageViewHeight = 120.f
        static let shadowImageViewHeight = 50.f
        static let favouriteLabelLeft = 5.f
        static let favouriteLabelBottom = -5.f
        static let titleLabelTop = 10.f
        static let titleLabelMaxHeight = 32.f
        static let latestUpdateLabelTop = 10.f
        static let latestUpdateLabelHeight = 10.f
    }
    
    let coverImageView = UIImageView().then{
        $0.cornerRadius = kCornerRadius
    }
    
    let shadowImageView = UIImageView().then{
        $0.image = Image.Home.shadow
    }
    
    let badgeButton = UIButton().then{
        $0.backgroundColor = UIColor.db_orange
        $0.setTitleColor(UIColor.db_white, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_10
        $0.isUserInteractionEnabled = false
        $0.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        
    }
    
    let favouriteLabel = UILabel().then{
        $0.textColor = UIColor.db_white
        $0.font = Font.SysFont.sys_12
    }
    
    let titleLabel = UILabel().then{
        $0.textColor = UIColor.db_black
        $0.font = Font.SysFont.sys_13
        $0.numberOfLines = 0
    }
    
    let latestUpdateLabel = UILabel().then{
        $0.font = Font.SysFont.sys_12
    }
    
    let watchProgressLabel = UILabel().then{
        $0.textColor = UIColor.db_lightGray
        $0.font = Font.SysFont.sys_12
    }
    
    override func initialize() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(latestUpdateLabel)
        contentView.addSubview(watchProgressLabel)
        coverImageView.addSubview(badgeButton)
        coverImageView.addSubview(shadowImageView)
        shadowImageView.addSubview(favouriteLabel)
    }
    
    func bind(reactor: DramaVerticalCellReactor) {
        
        let placeholderSize = CGSize(width: self.width, height: Metric.coverImageViewHeight)
        reactor.state.map{$0.coverURL}
            .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.title}
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.favourites}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: favouriteLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.badge}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: badgeButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.latestUpdate}
            .distinctUntilChanged()
            .bind(to: latestUpdateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.watchProgress}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: watchProgressLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.latestUpdateColor}
            .distinctUntilChanged()
            .bind(to: latestUpdateLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.badge == nil}
            .distinctUntilChanged()
            .bind(to: badgeButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.watchProgress == nil}
            .distinctUntilChanged()
            .bind(to: watchProgressLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.favourites == nil}
            .distinctUntilChanged()
            .bind(to: shadowImageView.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    class func size(reactor: DramaVerticalCellReactor) -> CGSize {
        
        let cellWidth = kScreenWidth/3.f
        
        var cellHeight: CGFloat = kCollectionItemPadding
        cellHeight += Metric.coverImageViewHeight
        cellHeight += Metric.titleLabelTop
        cellHeight += Metric.titleLabelMaxHeight
        cellHeight += Metric.latestUpdateLabelTop
        cellHeight += Metric.latestUpdateLabelHeight
        
        if let _ = reactor.currentState.watchProgress {
            cellHeight += Metric.latestUpdateLabelTop
            cellHeight += Metric.latestUpdateLabelHeight
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(kCollectionItemPadding)
            make.left.equalTo(reactor!.currentState.leftMargin)
            make.right.equalTo(-reactor!.currentState.rightMargin)
            make.height.equalTo(Metric.coverImageViewHeight)
        }
        
        badgeButton.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
        }
        
        shadowImageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(Metric.shadowImageViewHeight)
        }
        
        favouriteLabel.snp.makeConstraints { (make) in
            make.left.equalTo(Metric.favouriteLabelLeft)
            make.bottom.equalTo(Metric.favouriteLabelBottom)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(coverImageView)
            make.height.lessThanOrEqualTo(Metric.titleLabelMaxHeight)
            make.top.equalTo(coverImageView.snp.bottom).offset(Metric.titleLabelTop)
        }
        
        latestUpdateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.latestUpdateLabelTop)
            make.left.right.equalTo(coverImageView)
            make.height.equalTo(Metric.latestUpdateLabelHeight)
        }
        
        watchProgressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(latestUpdateLabel.snp.bottom).offset(Metric.latestUpdateLabelTop)
            make.left.right.equalTo(coverImageView)
            make.height.equalTo(Metric.latestUpdateLabelHeight)
        }
        
        if badgeButton.bounds != .zero {
            badgeButton.clipRectCorner(direction: [.bottomLeft,.topRight], cornerRadius: kCornerRadius)
        }
    }
    
    
}
