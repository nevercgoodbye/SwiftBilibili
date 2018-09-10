//
//  TogetherBannerCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/21.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import URLNavigator

final class TogetherBannerCell: BaseCollectionViewCell,View {
    
    private let bannerView = BilibiliBannerView().then{
        $0.cornerRadius = kCornerRadius
    }
    
    override func initialize() {
        
        self.backgroundColor = UIColor.clear
        contentView.addSubview(bannerView)
    }
    
    func bind(reactor: TogetherBannerCellReactor) {
        
        bannerView.reloadData(bannerModels: reactor.currentState.banners)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        setShadow()
        
        bannerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
}
