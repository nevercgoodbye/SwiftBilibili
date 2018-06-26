//
//  BilibiliBannerCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/8.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import FSPagerView

final class BilibiliBannerCell: FSPagerViewCell {

    let adLabel = UILabel().then{
        $0.text = "广告"
        $0.textColor = .db_white
        $0.cornerRadius = 2
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        $0.font = Font.SysFont.sys_12
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.insertSubview(adLabel, aboveSubview: imageView!)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        adLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(-6)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
    }
}
