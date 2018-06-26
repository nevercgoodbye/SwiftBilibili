//
//  TogetherTipCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/20.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class TogetherTipCell: BaseCollectionViewCell {
    
    private let tipButton = BilibiliButton().then{
        $0.setTitleColor(.db_pink, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_14
        $0.isUserInteractionEnabled = false
        $0.setImage(Image.Home.refresh, for: .normal)
        $0.setTitle("刚看到这里，点击刷新", for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.space = 5
        $0.imagePosition = .right
        $0.imageSize = CGSize(width: 13, height: 13)
    }
    
    override func initialize() {
        contentView.addSubview(tipButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tipButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
}
