//
//  LiveListHeaderView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class LiveListHeaderView: UICollectionReusableView {
    
    private var headerModel: LiveHeaderModel?
    
    let tagView = LiveTagView()
    
    let bannerView = BilibiliBannerView().then{
        $0.backgroundColor = .clear
        $0.cornerRadius = kCornerRadius
    }
    
    let partitionHeaderView = LiveListPartitionHeaderView.loadFromNib()

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(bannerView)
        addSubview(tagView)
        addSubview(partitionHeaderView)
    
        self.backgroundColor = UIColor.db_white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(headerModel:LiveHeaderModel?,bannerModels:[LiveAvModel]?,regionModels:[LiveAvModel]?,tagModels:[LiveTagModel]) {
        
        guard let headerModel = headerModel else { return }
        
        self.headerModel = headerModel
        
        if headerModel.count != nil {
            bannerView.isHidden = false
            tagView.isHidden = false
        }else{
            bannerView.isHidden = true
            tagView.isHidden = true
        }

        partitionHeaderView.reloadLiveData(headerModel: headerModel)
        
        if let bannerModels = bannerModels {
            bannerView.reloadData(bannerModels: bannerModels.map{BilibiliBannerModel(imageUrl: $0.pic ?? "", title: $0.title ?? "", link: $0.link ?? "", isAd: false)})
        }
        
        if let regionModels = regionModels {
            tagView.setupData(liveModels: regionModels, tagModels: tagModels)
        }
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        bannerView.snp.makeConstraints { (make) in
            make.left.equalTo(kCollectionItemPadding)
            make.right.equalTo(-kCollectionItemPadding)
            make.top.equalTo(kCollectionItemPadding)
            make.height.equalTo(kBannerHeight)
        }
        
        tagView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bannerView.snp.bottom)
            make.height.equalTo(170)
        }
        
        partitionHeaderView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}
