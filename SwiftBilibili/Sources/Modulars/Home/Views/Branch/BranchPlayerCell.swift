//
//  BranchPlayerCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/14.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class BranchPlayerCell: BaseCollectionViewCell,View {
    
    private let backgroundImageView = UIImageView().then{
        $0.cornerRadius = kCornerRadius
    }
    
    private let shadowView = UIView().then{
        $0.backgroundColor = UIColor.db_black.withAlphaComponent(0.3)
    }
    
    private let titleLabel = UILabel().then{
        $0.textColor = .db_white
        $0.font = Font.SysFont.sys_14
        $0.numberOfLines = 2
    }
   
    private let playButton = UIButton().then{
        $0.setImage(Image.Home.play, for: .normal)
    }
    
    override func initialize() {
        self.backgroundColor = UIColor.clear
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(shadowView)
        shadowView.addSubview(titleLabel)
        backgroundImageView.addSubview(playButton)
    }
    
    func bind(reactor: BranchPlayerCellReactor) {
        
        let placeholderSize = CGSize(width: self.width, height: self.height)
        reactor.state.map{$0.coverURL}
            .bind(to: backgroundImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
            .disposed(by: disposeBag)
        reactor.state.map{$0.title}
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    class func size(reactor: BranchPlayerCellReactor) -> CGSize {
        return CGSize(width: kScreenWidth - 2*kCollectionItemPadding, height: kNormalItemHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(10)
        }
        
        playButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }
    
    
}
