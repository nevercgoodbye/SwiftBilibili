//
//  TogetherAdCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/19.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit


final class TogetherAdCell: TogetherParentCell,View {

    private struct Metric {
        static let titleLabelLeft = 10.f
        static let titleLabelHeight = 30.f
        static let coverImageViewHeight = 100.f
        static let desLabelLeft = 10.f
        static let desLabelRight = -5.f
        static let tagLabelCornerRadius = 2.f
        static let tagLabelWidth = 28.f
        static let tagLabelHeight = 16.f
        static let tagLabelBorderWidth = 0.5.f
    }
    
    private let tagLabel = UILabel().then{
        $0.backgroundColor = .clear
        $0.text = "广告"
        $0.font = Font.SysFont.sys_11
        $0.cornerRadius = Metric.tagLabelCornerRadius
        $0.textAlignment = .center
        $0.borderWidth = Metric.tagLabelBorderWidth
        $0.borderColor = .db_lightGray
        $0.textColor = .db_lightGray
    }
    
    private let desLabel = UILabel().then{
        $0.textColor = .db_lightGray
        $0.font = Font.SysFont.sys_12
    }
    
    override func initialize() {

        super.initialize()
        contentView.addSubview(tagLabel)
        contentView.addSubview(desLabel)
    }
    
    func bind(reactor: TogetherAdCellReactor) {
        
        let placeholderSize = CGSize(width: reactor.currentState.cellSize.width, height: Metric.coverImageViewHeight)
        reactor.state.map{$0.coverURL}
                    .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
                    .disposed(by: disposeBag)
        reactor.state.map{$0.title}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map{$0.des}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: desLabel.rx.text)
            .disposed(by: disposeBag)

        
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)

        //Parent Method
        self.isShowDislikeView(reactor.together.isDislike)
        self.commonEvent(togetherModel: reactor.together)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    
        if reactor?.together.goto == .ad {
            
            titleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(Metric.titleLabelLeft)
                make.right.equalTo(dislikeButton.snp.right)
                make.top.equalToSuperview()
                make.height.equalTo(Metric.titleLabelHeight)
            }
            
            coverImageView.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom)
                make.height.equalTo(Metric.coverImageViewHeight)
            }
            
        }
    
        tagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.centerY.equalTo(dislikeButton)
            make.width.equalTo(Metric.tagLabelWidth)
            make.height.equalTo(Metric.tagLabelHeight)
        }
        
        desLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tagLabel.snp.right).offset(Metric.desLabelLeft)
            make.right.equalTo(dislikeButton.snp.left).offset(Metric.desLabelRight)
            make.centerY.equalTo(dislikeButton)
        }
    }
}
