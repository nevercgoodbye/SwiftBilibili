//
//  BranchPartitionView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/14.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class BranchPartitionView: UIView {

    let titleLabel = UILabel().then{
        $0.textColor = UIColor.db_black
        $0.font = Font.SysFont.sys_15
    }
    
    let moreLabel = UILabel().then{
        $0.textColor = UIColor.db_darkGray
        $0.text = "查看更多"
        $0.font = Font.SysFont.sys_15
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(moreLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadBranchData(headerModel:BranchItemModel) {
        
        let goto = headerModel.goto
        
        if goto != .content_rcmd && goto != .tag_rcmd { return }
        
        moreLabel.isHidden = headerModel.goto == .content_rcmd
        titleLabel.text = headerModel.title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(kCollectionItemPadding)
        }
        
        moreLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-kCollectionItemPadding)
            make.centerY.equalToSuperview()
        }
    }
}
