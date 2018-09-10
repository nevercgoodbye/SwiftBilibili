//
//  BranchSpecialCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/10.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class BranchSpecialCell: BaseCollectionViewCell,View {
    
    struct Metric {
        static let coverImageViewHeight = 110.f
        static let titleLabelTop = 10.f
        static let titleLabelLeft = 10.f
        static let titleLabelRight = -10.f
        static let titleLabelHeight = 15.f
        static let badgeButtonTop = 10.f
        static let badgeButtonHeight = 15.f
        static let descLabelHeight = 10.f
        static let descLabelLeft = 10.f
    }
    
    
    private let backgroundImageView = UIImageView().then{
        $0.backgroundColor = UIColor.db_white
        $0.cornerRadius = kCornerRadius
    }
    
    private let coverImageView = UIImageView().then{
        $0.contentMode = UIViewContentMode.scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then{
        $0.font = Font.SysFont.sys_13
        $0.textColor = .db_black
    }
    
    private let badgeButton = UIButton().then{
        $0.titleLabel?.font = Font.SysFont.sys_10
        $0.borderColor = .db_pink
        $0.borderWidth = 1
        $0.cornerRadius = 2
        $0.setTitleColor(.db_pink, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
    }
    
    private let descLabel = UILabel().then{
        $0.font = Font.SysFont.sys_12
        $0.textColor = UIColor.db_darkGray
    }
    
    override func initialize() {
        self.backgroundColor = UIColor.clear
        contentView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(coverImageView)
        backgroundImageView.addSubview(titleLabel)
        backgroundImageView.addSubview(badgeButton)
        backgroundImageView.addSubview(descLabel)
    }
    
    class func size(reactor:BranchSpecialCellReactor) -> CGSize {
        
        var height = Metric.coverImageViewHeight
        height += Metric.titleLabelTop
        height += Metric.titleLabelHeight
        height += Metric.badgeButtonTop
        height += Metric.badgeButtonHeight
        height += Metric.badgeButtonTop
        
        return CGSize(width: kScreenWidth - 2*kCollectionItemPadding, height: height)
    }
    
    
    func bind(reactor: BranchSpecialCellReactor) {
        
        let placeholderSize = CGSize(width: self.width, height: Metric.coverImageViewHeight)
        reactor.state.map{$0.coverURL}
            .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
            .disposed(by: disposeBag)
        reactor.state.map{$0.title}
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.badge}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: badgeButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        reactor.state.map{$0.desc}
            .distinctUntilChanged()
            .bind(to: descLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.badge == nil}
            .distinctUntilChanged()
            .bind(to: badgeButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setShadow()
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Metric.coverImageViewHeight)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(coverImageView.snp.bottom).offset(Metric.titleLabelTop)
            make.left.equalTo(Metric.titleLabelLeft)
            make.right.equalTo(Metric.titleLabelRight)
            make.height.equalTo(Metric.titleLabelHeight)
        }
        
        badgeButton.snp.makeConstraints { (make) in
            make.left.equalTo(Metric.titleLabelLeft)
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.badgeButtonTop)
            make.height.equalTo(Metric.badgeButtonHeight)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel)
            make.height.equalTo(Metric.descLabelHeight)
            if badgeButton.isHidden {
                make.left.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom).offset(Metric.badgeButtonTop)
            }else{
                make.left.equalTo(badgeButton.snp.right).offset(Metric.descLabelLeft)
                make.centerY.equalTo(badgeButton)
            }
        }
       
    }
}
