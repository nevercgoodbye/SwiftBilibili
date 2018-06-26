//
//  LiveListHeaderView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class LiveListHeaderView: UICollectionReusableView {
    
    private var headerModel: LivePartitionHeaderModel?
    
    let starShowView = LiveListStarShowView.loadFromNib()
    
    let bannerView = BilibiliBannerView().then{
        $0.backgroundColor = .clear
        $0.cornerRadius = kCornerRadius
    }
    
    let partitionHeaderView = LiveListPartitionHeaderView.loadFromNib()

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(bannerView)
        addSubview(starShowView)
        addSubview(partitionHeaderView)
    
        partitionHeaderView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {[unowned self] (_) in
            
             guard let header = self.headerModel else { return }
              
             switch header.partitionType {
             case .recommend:
                BilibiliRouter.push(.live_recommend)
             case .beauty:
                BilibiliRouter.push(.live_beauty)
             default:
                BilibiliRouter.push(BilibiliPushType.live_partition(id: header.partitionType.rawValue))
             }
        })
            .disposed(by: rx.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(headerModel:LivePartitionHeaderModel?,bannerModels:[LiveListBannerModel]?,starShows:[LiveStarShowModel]?) {
        
        guard let headerModel = headerModel else { return }
        
        self.headerModel = headerModel
        
        if headerModel.partitionType == .recommend {
            bannerView.isHidden = false
            starShowView.isHidden = starShows == nil
        }else{
            bannerView.isHidden = true
            starShowView.isHidden = true
        }

        let num = "\(headerModel.count)"
        
        let arrowName = headerModel.partitionType == .recommend ? "当前共有\(num)个主播" : "查看更多"
        
        let arrowNameAtt = NSMutableAttributedString(string: arrowName)
        
        if headerModel.partitionType == .recommend {
            
            let range = (arrowName as NSString).range(of: num)
            arrowNameAtt.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.db_pink], range: range)
        }

        
        partitionHeaderView.reloadData(iconUrl: headerModel.sub_icon.src, partitionName: headerModel.name, arrowName: arrowNameAtt)
        
        if let bannerModels = bannerModels {
            bannerView.reloadData(bannerModels: bannerModels.map{BilibiliBannerModel(imageUrl: $0.img, title: $0.title, link: $0.link, isAd: false)})
        }
        
        if let starShows = starShows {
            starShowView.starShows = starShows
            starShowView.collectionView.reloadData()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        bannerView.snp.makeConstraints { (make) in
            make.left.equalTo(kCollectionItemPadding)
            make.right.equalTo(-kCollectionItemPadding)
            make.top.equalTo(10)
            make.height.equalTo(kBannerHeight)
        }
        
        partitionHeaderView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.left.equalTo(kCollectionItemPadding)
            make.right.equalTo(-kCollectionItemPadding)
            make.height.equalTo(30)
        }
        
        starShowView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(bannerView.snp.bottom).offset(30)
            make.height.equalTo(190)
        }
    }
}
