//
//  DramaEditCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
final class DramaEditCell: BaseCollectionViewCell,View {
    
    private struct Metric {
        static let coverImageViewHeight = 100.f
        static let titleLabelTop = 10.f
        static let titleLabelLeft = 15.f
        static let titleLabelHeight = 16.f
        static let titleLabelRight = -15.f
        static let descLabelTop = 10.f
        static let descLabelHeight = 12.f
    }
    
    let backgroundImageView = UIImageView().then{
        $0.cornerRadius = kCornerRadius
        $0.backgroundColor = .clear
    }
    
    let coverImageView = UIImageView()
    
    
    let newImageView = UIImageView().then{
        $0.image = Image.Home.new
    }
    
    let bottomView = UIView().then{
        $0.backgroundColor = UIColor.db_gray
    }
    
    let titleLabel = UILabel().then{
        $0.textColor = UIColor.db_black
        $0.font = Font.SysFont.sys_14
    }
    
    let descLabel = UILabel().then{
        $0.textColor = UIColor.db_darkGray
        $0.font = Font.SysFont.sys_12
    }
    
    override func initialize() {
        contentView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(coverImageView)
        backgroundImageView.addSubview(bottomView)
        coverImageView.addSubview(newImageView)
        bottomView.addSubview(titleLabel)
        bottomView.addSubview(descLabel)
    }
    
    func bind(reactor: DramaEditCellReactor) {
       
        let placeholderSize = CGSize(width: kScreenWidth - 2*kCollectionItemPadding, height: Metric.coverImageViewHeight)
        reactor.state.map{$0.coverURL}
            .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
            .disposed(by: disposeBag)
        reactor.state.map{$0.title}
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.des}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: descLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.des == nil}
            .distinctUntilChanged()
            .bind(to: descLabel.rx.isHidden)
            .disposed(by: disposeBag)
        reactor.state.map{!$0.isNew}
            .distinctUntilChanged()
            .bind(to: newImageView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    class func size(reactor: DramaEditCellReactor) -> CGSize {
        
        var cellHeight: CGFloat = 0
        
        cellHeight += Metric.coverImageViewHeight
        cellHeight += Metric.titleLabelTop
        cellHeight += Metric.titleLabelHeight
        cellHeight += Metric.descLabelTop
        
        if let _ = reactor.currentState.des {
            cellHeight += Metric.descLabelHeight
            cellHeight += Metric.descLabelTop
        }
        
        return CGSize(width: kScreenWidth - 2*kCollectionItemPadding, height: cellHeight)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        coverImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Metric.coverImageViewHeight)
        }
        
        newImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(-20)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(coverImageView.snp.bottom)
            
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(Metric.titleLabelLeft)
            make.top.equalTo(Metric.titleLabelTop)
            make.right.equalTo(Metric.titleLabelRight)
            make.height.equalTo(Metric.titleLabelHeight)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.descLabelTop)
            make.right.equalTo(titleLabel)
            make.height.equalTo(Metric.descLabelHeight)
        }
    }
}
